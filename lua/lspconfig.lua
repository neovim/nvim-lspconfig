local configs = require 'lspconfig.configs'

local M = {
  util = require 'lspconfig.util',
}

M._root = {}

function M.available_servers()
  return vim.tbl_keys(configs)
end

local function restart_client(client, bufnr)
  client.stop()
  vim.defer_fn(function()
    if bufnr == nil or vim.api.nvim_buf_is_valid(bufnr) then
      configs[client.name].launch(bufnr)
    end
  end, 500)
end

-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
function M._root._setup()
  M._root.commands = {
    LspInfo = {
      function()
        require 'lspconfig.ui.lspinfo'()
      end,
      '-nargs=0',
      description = '`:LspInfo` Displays attached, active, and configured language servers',
    },
    LspLog = {
      function()
        vim.cmd(string.format('tabnew %s', vim.lsp.get_log_path()))
      end,
      '-nargs=0',
      description = '`:LspLog` Opens the Nvim LSP client log.',
    },
    LspStart = {
      function(server_name)
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
      end,
      '-nargs=? -complete=custom,v:lua.lsp_complete_configured_servers',
      description = '`:LspStart` Manually launches a language server.',
    },
    LspStop = {
      function(cmd_args)
        for _, client in ipairs(M.util.get_clients_from_cmd_args(cmd_args)) do
          client.stop()
        end
      end,
      '-nargs=? -complete=customlist,v:lua.lsp_get_active_client_ids',
      description = '`:LspStop` Manually stops the given language client(s),'
        .. ' if none are given stops current buffer client(s).'
        .. ' `:LspStop!` Manually stops all language client(s).',
      bang = function()
        for _, client in ipairs(vim.tbl_values(M.util.get_managed_clients())) do
          client.stop()
        end
      end,
    },
    LspRestart = {
      function(cmd_args)
        for _, client in ipairs(M.util.get_clients_from_cmd_args(cmd_args)) do
          restart_client(client)
        end
      end,
      '-nargs=? -complete=customlist,v:lua.lsp_get_active_client_ids',
      description = '`:LspRestart` Manually restart the given language client(s).'
        .. ' if none are given restarts current buffer client(s).'
        .. ' `:LspRestart!` Manually restarts all language client(s).',
      bang = function()
        local client_to_bufnr = {}
        for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
          for _, client in pairs(vim.lsp.get_active_clients { bufnr = bufnr }) do
            client_to_bufnr[client.id] = bufnr
          end
        end
        for _, client in ipairs(vim.tbl_values(M.util.get_managed_clients())) do
          restart_client(client, client_to_bufnr[client.id])
        end
      end,
    },
  }

  M.util.create_module_commands('_root', M._root.commands)
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
