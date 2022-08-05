local api = vim.api
local lspconfig = require 'lspconfig'

local lsp_get_active_client_ids = function()
  return vim.tbl_map(function(client)
    return ('%d (%s)'):format(client.id, client.name)
  end, require('lspconfig.util').get_managed_clients())
end

-- init lspconfig commands
local lspconfig_init = function()
  if vim.fn.exists('g:lspconfig') == 1 then
    return
  end
  vim.g.lspconfig = 1

  api.nvim_create_user_command('LspInfo', require 'lspconfig.ui.lspinfo', {
    nargs = 0,
    desc = '`:LspInfo` Displays attached, active, and configured language servers',
  })

  api.nvim_create_user_command('LspLog', function()
    vim.cmd(string.format('tabnew %s', vim.lsp.get_log_path()))
  end, {
    nargs = 0,
    desc = '`:LspLog` Opens the Nvim LSP client log.',
  })

  api.nvim_create_user_command('LspStart', function(server_name)
    lspconfig.lsp_start(server_name)
  end, {
    nargs = '?',
    complete = function(arg)
      local list = lspconfig.available_servers()
      return vim.tbl_filter(function(s)
        return string.match(s, '^' .. arg)
      end, list)
    end,
    desc = '`:LspStart` Manually launches a language server.',
  })

  api.nvim_create_user_command('LspStop', function(cmd_args)
    for _, client in ipairs(lspconfig.util.get_clients_from_cmd_args(cmd_args)) do
      client.stop()
    end
  end, {
    nargs = '?',
    complete = lsp_get_active_client_ids,
    desc = '`:LspStop` Manually stops the given language client(s).',
  })

  api.nvim_create_user_command('LspRestart', function(cmd_args)
    lspconfig.lsp_restart(cmd_args)
  end, {
    nargs = '?',
    complete = lsp_get_active_client_ids,
    desc = '`:LspRestart` Manually restart the given language client(s).',
  })
end

lspconfig_init()
