local configs = require 'lspconfig.configs'

local M = {
  util = require 'lspconfig.util',
}

M._root = {}

function M.available_servers()
  return vim.tbl_keys(configs)
end

-- start lsp server by server_name
function M.lsp_start(server_name)
  if server_name then
    if configs[server_name] then
      configs[server_name].launch()
    end
  else
    local buffer_filetype = vim.bo.filetype
    for _, config in pairs(configs) do
      for _, filetype_match in ipairs(config.filetypes or {}) do
        if buffer_filetype == filetype_match then
          config.launch()
        end
      end
    end
  end
end

-- restart lsp server
function M.lsp_restart(cmd_args)
  for _, client in ipairs(M.util.get_clients_from_cmd_args(cmd_args)) do
    client.stop()
    vim.defer_fn(function()
      configs[client.name].launch()
    end, 500)
  end
end

local mt = {}
function mt:__index(k)
  if configs[k] == nil then
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
