if vim.g.lspconfig ~= nil then
  return
end
vim.g.lspconfig = 1

local version_info = vim.version()
if vim.fn.has 'nvim-0.7' ~= 1 then
  local warning_str = string.format(
    '[lspconfig] requires neovim 0.7 or later. Detected neovim version: 0.%s.%s',
    version_info.minor,
    version_info.patch
  )
  vim.notify_once(warning_str)
  return
end

local lsp_complete_configured_servers = function(arg)
  return vim.tbl_filter(function(s)
    return s:sub(1, #arg) == arg
  end, vim.tbl_keys(require 'lspconfig.configs'))
end

local lsp_get_active_client_ids = function(arg)
  local clients = vim.tbl_map(function(client)
    return ('%d (%s)'):format(client.id, client.name)
  end, require('lspconfig.util').get_managed_clients())

  return vim.tbl_filter(function(s)
    return s:sub(1, #arg) == arg
  end, clients)
end

local get_clients_from_cmd_args = function(arg)
  local result = {}
  for id in (arg or ''):gmatch '(%d+)' do
    result[id] = vim.lsp.get_client_by_id(tonumber(id))
  end
  if vim.tbl_isempty(result) then
    return require('lspconfig.util').get_managed_clients()
  end
  return vim.tbl_values(result)
end

-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
vim.api.nvim_create_user_command('LspInfo', function()
  require 'lspconfig.ui.lspinfo'()
end, {
  desc = 'Displays attached, active, and configured language servers',
})

vim.api.nvim_create_user_command('LspStart', function(info)
  local server_name = info.args[1] ~= '' and info.args
  if server_name then
    local config = require('lspconfig.configs')[server_name]
    if config then
      config.launch()
    end
  else
    local other_matching_configs = require('lspconfig.util').get_other_matching_providers(vim.bo.filetype)
    for _, config in ipairs(other_matching_configs) do
      config.launch()
    end
  end
end, {
  desc = 'Manually launches a language server',
  nargs = '?',
  complete = lsp_complete_configured_servers,
})
vim.api.nvim_create_user_command('LspRestart', function(info)
  for _, client in ipairs(get_clients_from_cmd_args(info.args)) do
    client.stop()
    vim.defer_fn(function()
      require('lspconfig.configs')[client.name].launch()
    end, 500)
  end
end, {
  desc = 'Manually restart the given language client(s)',
  nargs = '?',
  complete = lsp_get_active_client_ids,
})

vim.api.nvim_create_user_command('LspStop', function(info)
  local current_buf = vim.api.nvim_get_current_buf()
  for _, client in ipairs(get_clients_from_cmd_args(info.args)) do
    local filetypes = client.config.filetypes
    if filetypes and vim.tbl_contains(filetypes, vim.bo[current_buf].filetype) then
      client.stop()
    end
  end
end, {
  desc = 'Manually stops the given language client(s)',
  nargs = '?',
  complete = lsp_get_active_client_ids,
})
