require 'user.lspconfig.configs'

local M = {
  util = require 'user.lspconfig.util',
}

function M.available_servers()
  vim.deprecate('user.lspconfig.available_servers', 'user.lspconfig.util.available_servers', '0.1.4', 'lspconfig')
  return M.util.available_servers()
end

local mt = {}
function mt:__index(k)
  if configs[k] == nil then
    local success, config = pcall(require, 'user.lspconfig.server_configurations.' .. k)
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
