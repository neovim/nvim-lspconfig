local validate = vim.validate
local api = vim.api
local lsp = vim.lsp
local nvim_eleven = vim.fn.has 'nvim-0.11' == 1

local iswin = vim.uv.os_uname().version:match 'Windows'

local M = { path = {} }

M.default_config = {
  log_level = lsp.protocol.MessageType.Warning,
  message_level = lsp.protocol.MessageType.Warning,
  settings = vim.empty_dict(),
  init_options = vim.empty_dict(),
  handlers = {},
  autostart = true,
  capabilities = lsp.protocol.make_client_capabilities(),
}

-- global on_setup hook
M.on_setup = nil

local function escape_wildcards(path)
  return path:gsub('([%[%]%?%*])', '\\%1')
end

--- Returns a function which matches a filepath against the given glob/wildcard patterns.
---
--- Also works with zipfile:/tarfile: buffers (via `strip_archive_subpath`).
function M.root_pattern(...)
  local patterns = M.tbl_flatten { ... }
  return function(startpath)
    startpath = M.strip_archive_subpath(startpath)
    for _, pattern in ipairs(patterns) do
      local match = M.search_ancestors(startpath, function(path)
        for _, p in ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, '/'), true, true)) do
          if vim.uv.fs_stat(p) then
            return path
          end
        end
      end)

      if match ~= nil then
        return match
      end
    end
  end
end

--- Appends `new_names` to `root_files` if `field` is found in any such file in any ancestor of `fname`.
---
--- NOTE: this does a "breadth-first" search, so is broken for multi-project workspaces:
--- https://github.com/neovim/nvim-lspconfig/issues/3818#issuecomment-2848836794
---
--- @param root_files string[] List of root-marker files to append to.
--- @param new_names string[] Potential root-marker filenames (e.g. `{ 'package.json', 'package.json5' }`) to inspect for the given `field`.
--- @param field string Field to search for in the given `new_names` files.
--- @param fname string Full path of the current buffer name to start searching upwards from.
function M.root_markers_with_field(root_files, new_names, field, fname)
  local path = vim.fn.fnamemodify(fname, ':h')
  local found = vim.fs.find(new_names, { path = path, upward = true })

  for _, f in ipairs(found or {}) do
    -- Match the given `field`.
    for line in io.lines(f) do
      if line:find(field) then
        root_files[#root_files + 1] = vim.fs.basename(f)
        break
      end
    end
  end

  return root_files
end

function M.insert_package_json(root_files, field, fname)
  return M.root_markers_with_field(root_files, { 'package.json', 'package.json5' }, field, fname)
end

-- For zipfile: or tarfile: virtual paths, returns the path to the archive.
-- Other paths are returned unaltered.
function M.strip_archive_subpath(path)
  -- Matches regex from zip.vim / tar.vim
  path = vim.fn.substitute(path, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1', '')
  path = vim.fn.substitute(path, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
  return path
end

function M.get_typescript_server_path(root_dir)
  local project_roots = vim.fs.find('node_modules', { path = root_dir, upward = true, limit = math.huge })
  for _, project_root in ipairs(project_roots) do
    local typescript_path = project_root .. '/typescript'
    local stat = vim.loop.fs_stat(typescript_path)
    if stat and stat.type == 'directory' then
      return typescript_path .. '/lib'
    end
  end
  return ''
end

---
---
---
--- Deprecated: Remove these functions when we drop support for legacy configs:
---
---
---

--- Deprecated in Nvim 0.11
function M.search_ancestors(startpath, func)
  if nvim_eleven then
    validate('func', func, 'function')
  end
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in vim.fs.parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

--- Deprecated in Nvim 0.11
local function is_fs_root(path)
  if iswin then
    return path:match '^%a:$'
  else
    return path == '/'
  end
end

--- Deprecated in Nvim 0.11
local function traverse_parents(path, cb)
  path = vim.uv.fs_realpath(path)
  local dir = path
  -- Just in case our algo is buggy, don't infinite loop.
  for _ = 1, 100 do
    dir = vim.fs.dirname(dir)
    if not dir then
      return
    end
    -- If we can't ascend further, then stop looking.
    if cb(dir, path) then
      return dir, path
    end
    if is_fs_root(dir) then
      break
    end
  end
end

--- Deprecated in Nvim 0.11
function M.path.is_descendant(root, path)
  if not path then
    return false
  end

  local function cb(dir, _)
    return dir == root
  end

  local dir, _ = traverse_parents(path, cb)

  return dir == root
end

function M.tbl_flatten(t)
  --- @diagnostic disable-next-line:deprecated
  return nvim_eleven and vim.iter(t):flatten(math.huge):totable() or vim.tbl_flatten(t)
end

--- @deprecated
function M.get_config_by_ft(filetype)
  local configs = require 'lspconfig.configs'
  local matching_configs = {}
  for _, config in pairs(configs) do
    local filetypes = config.filetypes or {}
    for _, ft in pairs(filetypes) do
      if ft == filetype then
        table.insert(matching_configs, config)
      end
    end
  end
  return matching_configs
end

--- @deprecated use `vim.lsp.config` in Nvim 0.11+ instead.
function M.available_servers()
  local servers = {}
  local configs = require 'lspconfig.configs'
  for server, config in pairs(configs) do
    if config.manager ~= nil then
      table.insert(servers, server)
    end
  end
  return servers
end

--- @deprecated use `vim.fn.isdirectory(path) == 1` instead
--- @param filename string
--- @return boolean
function M.path.is_dir(filename)
  return vim.fn.isdirectory(filename) == 1
end

--- @deprecated use `(vim.uv.fs_stat(path) or {}).type == 'file'` instead
--- @param path string
--- @return boolean
function M.path.is_file(path)
  return (vim.uv.fs_stat(path) or {}).type == 'file'
end

--- @deprecated use `vim.fs.dirname` instead
M.path.dirname = vim.fs.dirname

--- @deprecated use `vim.fs.normalize` instead
M.path.sanitize = vim.fs.normalize

--- @deprecated use `vim.uv.fs_stat` instead
--- @param filename string
--- @return string|false
function M.path.exists(filename)
  local stat = vim.uv.fs_stat(filename)
  return stat and stat.type or false
end

--- @deprecated use `table.concat({"path1", "path2"})` or regular string concatenation instead
function M.path.join(...)
  return table.concat({ ... }, '/')
end

--- @deprecated use `vim.fn.has('win32') == 1 and ';' or ':'` instead
M.path.path_separator = vim.fn.has('win32') == 1 and ';' or ':'

--- @deprecated use `vim.fs.parents(path)` instead
M.path.iterate_parents = vim.fs.parents

--- @deprecated use `vim.fs.dirname(vim.fs.find('.hg', { path = startpath, upward = true })[1])` instead
function M.find_mercurial_ancestor(startpath)
  return vim.fs.dirname(vim.fs.find('.hg', { path = startpath, upward = true })[1])
end

--- @deprecated use `vim.fs.dirname(vim.fs.find('node_modules', { path = startpath, upward = true })[1])` instead
function M.find_node_modules_ancestor(startpath)
  return vim.fs.dirname(vim.fs.find('node_modules', { path = startpath, upward = true })[1])
end

--- @deprecated use `vim.fs.dirname(vim.fs.find('package.json', { path = startpath, upward = true })[1])` instead
function M.find_package_json_ancestor(startpath)
  return vim.fs.dirname(vim.fs.find('package.json', { path = startpath, upward = true })[1])
end

--- @deprecated use `vim.fs.dirname(vim.fs.find('.git', { path = startpath, upward = true })[1])` instead
function M.find_git_ancestor(startpath)
  return vim.fs.dirname(vim.fs.find('.git', { path = startpath, upward = true })[1])
end

--- @deprecated Will be removed. Do not use.
function M.get_active_clients_list_by_ft(filetype)
  local clients = vim.lsp.get_clients()
  local clients_list = {}
  for _, client in pairs(clients) do
    --- @diagnostic disable-next-line:undefined-field
    local filetypes = client.config.filetypes or {}
    for _, ft in pairs(filetypes) do
      if ft == filetype then
        table.insert(clients_list, client.name)
      end
    end
  end
  return clients_list
end

--- @deprecated Will be removed. Do not use.
function M.get_other_matching_providers(filetype)
  local configs = require 'lspconfig.configs'
  local active_clients_list = M.get_active_clients_list_by_ft(filetype)
  local other_matching_configs = {}
  for _, config in pairs(configs) do
    if not vim.tbl_contains(active_clients_list, config.name) then
      local filetypes = config.filetypes or {}
      for _, ft in pairs(filetypes) do
        if ft == filetype then
          table.insert(other_matching_configs, config)
        end
      end
    end
  end
  return other_matching_configs
end

--- @deprecated Use vim.lsp.get_clients instead.
function M.get_lsp_clients(filter)
  --- @diagnostic disable-next-line:deprecated
  return nvim_eleven and lsp.get_clients(filter) or lsp.get_active_clients(filter)
end

--- @deprecated Will be removed. Do not use.
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

--- @deprecated Will be removed. Do not use.
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

--- @deprecated Will be removed. Do not use.
function M.get_active_client_by_name(bufnr, servername)
  return vim.lsp.get_clients({ bufnr = bufnr, name = servername })[1]
end

-- Maps lspconfig-style command options to nvim_create_user_command (i.e. |command-attributes|) option names.
local opts_aliases = {
  ['description'] = 'desc',
}

--- @deprecated Will be removed. Do not use.
---@param command_definition table<string | integer, any>
function M._parse_user_command_options(command_definition)
  ---@type table<string, string | boolean | number>
  local opts = {}
  for k, v in pairs(command_definition) do
    if type(k) == 'string' then
      local attribute = k.gsub(k, '^%-+', '')
      opts[opts_aliases[attribute] or attribute] = v
    elseif type(k) == 'number' and type(v) == 'string' and v:match '^%-' then
      -- Splits strings like "-nargs=* -complete=customlist,v:lua.something" into { "-nargs=*", "-complete=customlist,v:lua.something" }
      for _, command_attribute in ipairs(vim.split(v, '%s')) do
        -- Splits attribute into a key-value pair, like "-nargs=*" to { "-nargs", "*" }
        local attribute, value = unpack(vim.split(command_attribute, '=', { plain = true }))
        attribute = attribute.gsub(attribute, '^%-+', '')
        opts[opts_aliases[attribute] or attribute] = value or true
      end
    end
  end
  return opts
end

--- @deprecated Will be removed. Do not use.
function M.create_module_commands(module_name, commands)
  for command_name, def in pairs(commands) do
    if type(def) ~= 'function' then
      local opts = M._parse_user_command_options(def)
      api.nvim_create_user_command(command_name, function(info)
        require('lspconfig')[module_name].commands[command_name][1](unpack(info.fargs))
      end, opts)
    end
  end
end

--- Note: In Nvim 0.11+ this currently has no public interface, the healthcheck uses the private
--- `vim.lsp._enabled_configs`:
--- https://github.com/neovim/neovim/blob/28e819018520a2300eaeeec6794ffcd614b25dd2/runtime/lua/vim/lsp/health.lua#L186
--- @deprecated Will be removed. Do not use.
function M.get_managed_clients()
  local configs = require 'lspconfig.configs'
  local clients = {}
  for _, config in pairs(configs) do
    if config.manager then
      vim.list_extend(clients, config.manager:clients())
    end
  end
  return clients
end

--- @deprecated Will be removed. Do not use.
function M.bufname_valid(bufname)
  if bufname:match '^/' or bufname:match '^[a-zA-Z]:' or bufname:match '^zipfile://' or bufname:match '^tarfile:' then
    return true
  end
  return false
end

--- @deprecated Will be removed. Do not use.
function M.validate_bufnr(bufnr)
  if nvim_eleven then
    validate('bufnr', bufnr, 'number')
  end
  return bufnr == 0 and api.nvim_get_current_buf() or bufnr
end

return M
