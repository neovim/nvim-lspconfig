local configs = require 'lspconfig.configs'

local M = {
  util = require 'lspconfig.util',
}

--- Deprecated config names.
---
---@class Alias
---@field to string The new name of the server
---@field version string The version that the alias will be removed in
---@field inconfig? boolean need shown in lspinfo
local aliases = {
  ['fennel-ls'] = {
    to = 'fennel_ls',
    version = '0.2.1',
  },
  ruby_ls = {
    to = 'ruby_lsp',
    version = '0.2.1',
  },
  ['starlark-rust'] = {
    to = 'starlark_rust',
    version = '0.2.1',
  },
  sumneko_lua = {
    to = 'lua_ls',
    version = '0.2.1',
  },
  tsserver = {
    to = 'ts_ls',
    version = '0.2.1',
  },
}

---@return Alias
---@param name string|nil get this alias, or nil to get all aliases that were used in the current session.
M.server_aliases = function(name)
  if name then
    return aliases[name]
  end
  local used_aliases = {}
  for sname, alias in pairs(aliases) do
    if alias.inconfig then
      used_aliases[sname] = alias
    end
  end
  return used_aliases
end

local mt = {}
function mt:__index(k)
  if configs[k] == nil then
    local alias = M.server_aliases(k)
    if alias then
      vim.deprecate(k, alias.to, alias.version, 'lspconfig', false)
      alias.inconfig = true
      k = alias.to
    end

    local success, config = pcall(require, 'lspconfig.server_configurations.' .. k)
    if success then
      configs[k] = config
    else
      vim.notify(
        string.format(
          '[lspconfig] Cannot access configuration for %s. Ensure this server is listed in '
            .. '`server_configurations.md` or added as a custom server.',
          k
        ),
        vim.log.levels.WARN
      )
      -- Return a dummy function for compatibility with user configs
      return { setup = function() end }
    end
  end
  return configs[k]
end

return setmetatable(M, mt)
