local validate = vim.validate
local api = vim.api
local lsp = vim.lsp
local uv = vim.loop

local M = {}

function M.validate_bufnr(bufnr)
  validate {
    bufnr = { bufnr, 'n' }
  }
  return bufnr == 0 and api.nvim_get_current_buf() or bufnr
end

function M.add_hook_before(fn, new_fn)
  if fn then
    return function(...)
      -- TODO which result?
      new_fn(...)
      return fn(...)
    end
  else
    return new_fn
  end
end

function M.add_hook_after(fn, new_fn)
  if fn then
    return function(...)
      -- TODO which result?
      fn(...)
      return new_fn(...)
    end
  else
    return new_fn
  end
end

local function split_lines(s)
  return vim.split(s, "\n", true)
end

function M.tbl_deep_extend(dst, ...)
  validate { dst = { dst, 't' } }
  for i = 1, select("#", ...) do
    local t = select(i, ...)
    validate { arg = { t, 't' } }
    for k, v in pairs(t) do
      if type(v) == 'table' and not vim.tbl_islist(v) then
        dst[k] = M.tbl_deep_extend(dst[k] or {}, v)
      else
        dst[k] = v
      end
    end
  end
  return dst
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
        string.format("lua require'common_lsp/%s'.commands[%q][1]()", module_name, command_name))
    api.nvim_command(table.concat(parts, " "))
  end
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

  local is_windows = uv.os_uname().sysname == "Windows"
  local path_sep = is_windows and "\\" or "/"

  local is_fs_root
  if is_windows then
    is_fs_root = function(path)
      return path:match("^%a:\\\\$")
    end
  else
    is_fs_root = function(path)
      return path == "/"
    end
  end

  local dirname
  do
    local strip_dir_pat = path_sep.."([^"..path_sep.."]+)$"
    local strip_sep_pat = path_sep.."$"
    dirname = function(path)
      local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
      if #result == 0 then
        return "/"
      end
      return result
    end
  end

  local function path_join(...)
    return table.concat(vim.tbl_flatten {...}, path_sep)
  end

  -- Traverse the path calling cb along the way.
  local function traverse_parents(path, cb)
    path = uv.fs_realpath(path)
    local dir = path
    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
      dir = dirname(dir)
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
      if is_fs_root(v) then return end
      return dirname(v), path
    end
    return it, path, path
  end

  return {
    is_dir = is_dir;
    is_file = is_file;
    exists = exists;
    sep = path_sep;
    dirname = dirname;
    join = path_join;
    traverse_parents = traverse_parents;
    iterate_parents = iterate_parents;
  }
end)()


-- Returns a function(root_dir), which, when called with a root_dir it hasn't
-- seen before, will call make_config(root_dir) and start a new client.
function M.server_per_root_dir_manager(make_config)
  local clients = {}
  local manager = {}

  function manager.add(root_dir)
    if not root_dir then return end

    -- Check if we have a client alredy or start and store it.
    local client_id = clients[root_dir]
    if not client_id then
      local new_config = make_config(root_dir)
      new_config.root_dir = root_dir
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

function M.search_ancestors(startpath, fn)
  validate { fn = {fn, 'f'} }
  if fn(startpath) then return startpath end
  for path in M.path.iterate_parents(startpath) do
    if fn(path) then return path end
  end
end

function M.root_pattern(...)
  local patterns = vim.tbl_flatten {...}
  local function matcher(path)
    for _, pattern in ipairs(patterns) do
      if M.path.exists(M.path.join(path, pattern)) then
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

return M
-- vim:et ts=2 sw=2
