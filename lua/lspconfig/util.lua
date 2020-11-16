local vim = vim
local validate = vim.validate
local api = vim.api
local lsp = vim.lsp
local uv = vim.loop
local fn = vim.fn

local M = {}

M.default_config = {
  log_level = lsp.protocol.MessageType.Warning;
  message_level = lsp.protocol.MessageType.Warning;
  settings = vim.empty_dict();
  init_options = vim.empty_dict();
  handlers = {};
}

function M.validate_bufnr(bufnr)
  validate {
    bufnr = { bufnr, 'n' }
  }
  return bufnr == 0 and api.nvim_get_current_buf() or bufnr
end

function M.add_hook_before(func, new_fn)
  if func then
    return function(...)
      -- TODO which result?
      new_fn(...)
      return func(...)
    end
  else
    return new_fn
  end
end

function M.add_hook_after(func, new_fn)
  if func then
    return function(...)
      -- TODO which result?
      func(...)
      return new_fn(...)
    end
  else
    return new_fn
  end
end

function M.tbl_deep_extend(behavior, ...)
  if (behavior ~= 'error' and behavior ~= 'keep' and behavior ~= 'force') then
    error('invalid "behavior": '..tostring(behavior))
  end

  if select('#', ...) < 2 then
    error('wrong number of arguments (given '..tostring(1 + select('#', ...))..', expected at least 3)')
  end

  local ret = {}
  if vim._empty_dict_mt ~= nil and getmetatable(select(1, ...)) == vim._empty_dict_mt then
    ret = vim.empty_dict()
  end

  for i = 1, select('#', ...) do
    local tbl = select(i, ...)
    vim.validate{["after the second argument"] = {tbl,'t'}}
    if tbl then
      for k, v in pairs(tbl) do
        if type(v) == 'table' and not vim.tbl_islist(v) then
          ret[k] = M.tbl_deep_extend(behavior, ret[k] or vim.empty_dict(), v)
        elseif behavior ~= 'force' and ret[k] ~= nil then
          if behavior == 'error' then
            error('key found in more than one map: '..k)
          end  -- Else behavior is "keep".
        else
          ret[k] = v
        end
      end
    end
  end
  return ret
end

function M.nvim_multiline_command(command)
  validate { command = { command, 's' } }
  for line in vim.gsplit(command, "\n", true) do
    api.nvim_command(line)
  end
end

function M.lookup_section(settings, section)
  for part in vim.gsplit(section, '.', true) do
    settings = settings[part]
    if not settings then
      return
    end
  end
  return settings
end

function M.create_module_commands(module_name, commands)
  for command_name, def in pairs(commands) do
    local parts = {"command!"}
    -- Insert attributes.
    for k, v in pairs(def) do
      if type(k) == 'string' and type(v) == 'boolean' and v then
        table.insert(parts, "-"..k)
      elseif type(k) == 'number' and type(v) == 'string' and v:match("^%-") then
        table.insert(parts, v)
      end
    end
    table.insert(parts, command_name)
    -- The command definition.
    table.insert(parts,
        string.format("lua require'lspconfig'[%q].commands[%q][1](<f-args>)", module_name, command_name))
    api.nvim_command(table.concat(parts, " "))
  end
end

function M.has_bins(...)
  for i = 1, select("#", ...) do
    if 0 == fn.executable((select(i, ...))) then
      return false
    end
  end
  return true
end

-- Some path utilities
M.path = (function()
  local function exists(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
  end

  local function is_dir(filename)
    return exists(filename) == 'directory'
  end

  local function is_file(filename)
    return exists(filename) == 'file'
  end

  local is_windows = uv.os_uname().version:match("Windows")
  local path_sep = is_windows and "\\" or "/"

  local is_fs_root
  if is_windows then
    is_fs_root = function(path)
      return path:match("^%a:$")
    end
  else
    is_fs_root = function(path)
      return path == "/"
    end
  end

  local function is_absolute(filename)
    if is_windows then
      return filename:match("^%a:") or filename:match("^\\\\")
    else
      return filename:match("^/")
    end
  end

  local dirname
  do
    local strip_dir_pat = path_sep.."([^"..path_sep.."]+)$"
    local strip_sep_pat = path_sep.."$"
    dirname = function(path)
      if not path then return end
      local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
      if #result == 0 then
        return "/"
      end
      return result
    end
  end

  local function path_join(...)
    local result =
      table.concat(
        vim.tbl_flatten {...}, path_sep):gsub(path_sep.."+", path_sep)
    return result
  end

  -- Traverse the path calling cb along the way.
  local function traverse_parents(path, cb)
    path = uv.fs_realpath(path)
    local dir = path
    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
      dir = dirname(dir)
      if not dir then return end
      -- If we can't ascend further, then stop looking.
      if cb(dir, path) then
        return dir, path
      end
      if is_fs_root(dir) then
        break
      end
    end
  end

  -- Iterate the path until we find the rootdir.
  local function iterate_parents(path)
    path = uv.fs_realpath(path)
    local function it(s, v)
      if not v then return end
      if is_fs_root(v) then return end
      return dirname(v), path
    end
    return it, path, path
  end

  local function is_descendant(root, path)
    if (not path) then
      return false;
    end

    local function cb(dir, _)
      return dir == root;
    end

    local dir, _ = traverse_parents(path, cb);

    return dir == root;
  end

  return {
    is_dir = is_dir;
    is_file = is_file;
    is_absolute = is_absolute;
    exists = exists;
    sep = path_sep;
    dirname = dirname;
    join = path_join;
    traverse_parents = traverse_parents;
    iterate_parents = iterate_parents;
    is_descendant = is_descendant;
  }
end)()


-- Returns a function(root_dir), which, when called with a root_dir it hasn't
-- seen before, will call make_config(root_dir) and start a new client.
function M.server_per_root_dir_manager(_make_config)
  local clients = {}
  local manager = {}

  function manager.add(root_dir)
    if not root_dir then return end
    if not M.path.is_dir(root_dir) then return end

    -- Check if we have a client alredy or start and store it.
    local client_id = clients[root_dir]
    if not client_id then
      local new_config = _make_config(root_dir)
      new_config.on_exit = M.add_hook_before(new_config.on_exit, function()
        clients[root_dir] = nil
      end)
      client_id = lsp.start_client(new_config)
      clients[root_dir] = client_id
    end
    return client_id
  end

  function manager.clients()
    local res = {}
    for _, id in pairs(clients) do
      local client = lsp.get_client_by_id(id)
      if client then
        table.insert(res, client)
      end
    end
    return res
  end

  return manager
end

function M.search_ancestors(startpath, func)
  validate { func = {func, 'f'} }
  if func(startpath) then return startpath end
  for path in M.path.iterate_parents(startpath) do
    if func(path) then return path end
  end
end

function M.root_pattern(...)
  local patterns = vim.tbl_flatten {...}
  local function matcher(path)
    for _, pattern in ipairs(patterns) do
      if M.path.exists(vim.fn.glob(M.path.join(path, pattern))) then
        return path
      end
    end
  end
  return function(startpath)
    return M.search_ancestors(startpath, matcher)
  end
end
function M.find_git_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_dir(M.path.join(path, ".git")) then
      return path
    end
  end)
end
function M.find_node_modules_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_dir(M.path.join(path, "node_modules")) then
      return path
    end
  end)
end
function M.find_package_json_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_file(M.path.join(path, "package.json")) then
      return path
    end
  end)
end

local function validate_string_list(t)
  for _, v in ipairs(t) do
    if type(v) ~= 'string' then
      return false
    end
  end
  return true
end

local function map_list(t, func)
  local res = {}
  for i, v in ipairs(t) do table.insert(res, func(v, i)) end
  return res
end

local function zip_lists_to_map(a, b)
  assert(#a == #b)
  local res = {}
  for i = 1, #a do res[a[i]] = b[i] end
  return res
end

local base_install_dir = M.path.join(fn.stdpath("cache"), "lspconfig")
M.base_install_dir = base_install_dir
function M.npm_installer(config)
  validate {
    server_name = {config.server_name, 's'};
    packages = {config.packages, validate_string_list, 'List of npm package names'};
    binaries = {config.binaries, validate_string_list, 'List of binary names'};
    post_install_script = {config.post_install_script, 's', true};
  }

  local install_dir = M.path.join(base_install_dir, config.server_name)
  local bin_dir = M.path.join(install_dir, "node_modules", ".bin")
  local function bin_path(name)
    return M.path.join(bin_dir, name)
  end

  local binary_paths = map_list(config.binaries, bin_path)

  local function get_install_info()
    return {
      bin_dir = bin_dir;
      install_dir = install_dir;
      binaries = zip_lists_to_map(config.binaries, binary_paths);
      is_installed = M.has_bins(unpack(binary_paths));
    }
  end

  local function install()
    -- TODO(ashkan) need all binaries or just the first?
    if M.has_bins(unpack(config.binaries)) then
      return print(config.server_name, "is already installed (not by Nvim)")
    end
    if not M.has_bins("sh", "npm", "mkdir") then
      api.nvim_err_writeln('Installation requires "sh", "npm", "mkdir"')
      return
    end
    if get_install_info().is_installed then
      return print(config.server_name, "is already installed")
    end
    local install_params = {
      packages = table.concat(config.packages, ' ');
      install_dir = install_dir;
      post_install_script = config.post_install_script or '';
    }
    local cmd = io.popen("sh", "w")
    local install_script = ([[
    set -e
    mkdir -p "{{install_dir}}"
    cd "{{install_dir}}"
    [ ! -f package.json ] && npm init -y
    npm install {{packages}} --no-package-lock --no-save --production
    {{post_install_script}}
    ]]):gsub("{{(%S+)}}", install_params)
    cmd:write(install_script)
    cmd:close()
    if not get_install_info().is_installed then
      api.nvim_err_writeln('Installation of ' .. config.server_name .. ' failed')
    end
  end

  return {
    install = install;
    info = get_install_info;
  }
end

function M.sh(script, cwd)
  assert(cwd and M.path.is_dir(cwd), "sh: Invalid directory")
  -- switching to insert mode makes the buffer scroll as new output is added
  -- and makes it easy and intuitive to cancel the operation with Ctrl-C
  api.nvim_command("10new | startinsert")
  local bufnr = api.nvim_get_current_buf()
  local function on_exit(job_id, code, event_type)
    if code == 0 then
      api.nvim_command("silent bwipeout! "..bufnr)
    end
  end
  fn.termopen({"sh", "-c", script}, {cwd = cwd, on_exit = on_exit})
end

function M.format_vspackage_url(extension_name)
  local org, package = unpack(vim.split(extension_name, ".", true))
  assert(org and package)
  return string.format("https://marketplace.visualstudio.com/_apis/public/gallery/publishers/%s/vsextensions/%s/latest/vspackage", org, package)
end


function M.utf8_config(config)
  config.capabilities = config.capabilities or lsp.protocol.make_client_capabilities()
  config.capabilities.offsetEncoding = {"utf-8", "utf-16"}
  function config.on_init(client, result)
    if result.offsetEncoding then
      client.offset_encoding = result.offsetEncoding
    end
  end
  return config
end

return M
-- vim:et ts=2 sw=2
