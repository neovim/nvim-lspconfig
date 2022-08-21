if vim.fn.exists 'g:lspconfig' == 1 then
  return
end

vim.g.lspconfig = 1

local api = vim.api

local lsp_get_active_client_ids = function()
  return vim.tbl_map(function(client)
    return ('%d (%s)'):format(client.id, client.name)
  end, require('lspconfig.util').get_managed_clients())
end

api.nvim_create_user_command('LspInfo', function(args)
  require 'lspconfig.ui.lspinfo'(args.fargs)
end, {
  nargs = '*',
  desc = '`:LspInfo` Displays attached, active, and configured language servers',
})

api.nvim_create_user_command('LspLog', function()
  vim.cmd(string.format('tabnew %s', vim.lsp.get_log_path()))
end, {
  nargs = 0,
  desc = '`:LspLog` Opens the Nvim LSP client log.',
})

api.nvim_create_user_command('LspStart', function(args)
  require('lspconfig').lsp_start(args.args)
end, {
  nargs = '?',
  complete = function(arg)
    return vim.tbl_filter(function(s)
      return s:sub(1, #arg) == arg
    end, require('lspconfig').available_servers())
  end,
  desc = '`:LspStart` Manually launches a language server.',
})

api.nvim_create_user_command('LspStop', function(cmd_args)
  for _, client in ipairs(require('lspconfig').util.get_clients_from_cmd_args(cmd_args)) do
    client.stop()
  end
end, {
  nargs = '?',
  complete = lsp_get_active_client_ids,
  desc = '`:LspStop` Manually stops the given language client(s).',
})

api.nvim_create_user_command('LspRestart', function(cmd_args)
  require('lspconfig').lsp_restart(cmd_args)
end, {
  nargs = '?',
  complete = lsp_get_active_client_ids,
  desc = '`:LspRestart` Manually restart the given language client(s).',
})
