local configs = require 'lspconfig.configs'

local M = {
  util = require 'lspconfig.util',
}

--- Deprecated config names.
---
---@class Alias
---@field to string The new name of the server
---@field version string The version that the alias will be removed in
---@field inconfig? boolean should display in healthcheck (`:checkhealth lspconfig`)
local aliases = {
  ['fennel-ls'] = {
    to = 'fennel_ls',
    version = '0.2.1',
  },
  ruby_ls = {
    to = 'ruby_lsp',
    version = '0.2.1',
  },
  ruff_lsp = {
    to = 'ruff',
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
  bufls = {
    to = 'buf_ls',
    version = '0.2.1',
  },
  typst_lsp = {
    to = 'tinymist',
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

-- Temporary port of Nvim 0.10 vim.version:tostring.
---@param version vim.Version
local function version_string(version)
  assert(version.major and version.minor and version.patch, 'invalid vim.Version table')
  local ret = table.concat({ version.major, version.minor, version.patch }, '.')
  if version.prerelease then
    ret = ret .. '-' .. version.prerelease
  end
  if version.build and version.build ~= vim.NIL then
    ret = ret .. '+' .. version.build
  end
  return ret
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

    local success, config = pcall(require, 'lspconfig.configs.' .. k)
    if success then
      configs[k] = config
    else
      vim.notify(
        string.format(
          '[lspconfig] config "%s" not found. Ensure it is listed in `configs.md` or added as a custom server.',
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

local minimum_neovim_version = '0.10'
if vim.fn.has('nvim-' .. minimum_neovim_version) == 0 then
  local msg = string.format(
    'nvim-lspconfig requires Nvim version %s, but you are running: %s',
    minimum_neovim_version,
    vim.version and version_string(vim.version()) or 'older than v0.5.0'
  )
  error(msg)
end

return setmetatable(M, mt)
