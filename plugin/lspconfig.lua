local api, lsp = vim.api, vim.lsp

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

local completion_sort = function(items)
  table.sort(items)
  return items
end

local lsp_complete_configured_servers = function(arg)
  return completion_sort(vim.tbl_filter(function(s)
    return s:sub(1, #arg) == arg
  end, require('lspconfig.util').available_servers()))
end

local lsp_get_active_client_ids = function(arg)
  local clients = vim.tbl_map(function(client)
    return ('%d (%s)'):format(client.id, client.name)
  end, require('lspconfig.util').get_managed_clients())

  return completion_sort(vim.tbl_filter(function(s)
    return s:sub(1, #arg) == arg
  end, clients))
end

local get_clients_from_cmd_args = function(arg)
  local result = {}
  for id in (arg or ''):gmatch '(%d+)' do
    result[id] = lsp.get_client_by_id(tonumber(id))
  end
  if vim.tbl_isempty(result) then
    return require('lspconfig.util').get_managed_clients()
  end
  return vim.tbl_values(result)
end

for group, hi in pairs {
  LspInfoBorder = { link = 'Label', default = true },
  LspInfoList = { link = 'Function', default = true },
  LspInfoTip = { link = 'Comment', default = true },
  LspInfoTitle = { link = 'Title', default = true },
  LspInfoFiletype = { link = 'Type', default = true },
} do
  api.nvim_set_hl(0, group, hi)
end

-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
api.nvim_create_user_command('LspInfo', function()
  require 'lspconfig.ui.lspinfo'()
end, {
  desc = 'Displays attached, active, and configured language servers',
})

api.nvim_create_user_command('LspStart', function(info)
  local server_name = string.len(info.args) > 0 and info.args or nil
  if server_name then
    local config = require('lspconfig.configs')[server_name]
    if config then
      config.launch()
      return
    end
  end

  local matching_configs = require('lspconfig.util').get_config_by_ft(vim.bo.filetype)
  for _, config in ipairs(matching_configs) do
    config.launch()
  end
end, {
  desc = 'Manually launches a language server',
  nargs = '?',
  complete = lsp_complete_configured_servers,
})

api.nvim_create_user_command('LspRestart', function(info)
  local detach_clients = {}
  for _, client in ipairs(get_clients_from_cmd_args(info.args)) do
    client.stop()
    detach_clients[client.name] = client
  end
  local timer = vim.loop.new_timer()
  timer:start(
    500,
    100,
    vim.schedule_wrap(function()
      for client_name, client in pairs(detach_clients) do
        if client.is_stopped() then
          require('lspconfig.configs')[client_name].launch()
          detach_clients[client_name] = nil
        end
      end

      if next(detach_clients) == nil and not timer:is_closing() then
        timer:close()
      end
    end)
  )
end, {
  desc = 'Manually restart the given language client(s)',
  nargs = '?',
  complete = lsp_get_active_client_ids,
})

api.nvim_create_user_command('LspStop', function(info)
  local current_buf = vim.api.nvim_get_current_buf()
  local server_id, force
  local arguments = vim.split(info.args, '%s')
  for _, v in pairs(arguments) do
    if v == '++force' then
      force = true
    elseif v:find '^[0-9]+$' then
      server_id = v
    end
  end

  if not server_id then
    local servers_on_buffer = lsp.get_active_clients { bufnr = current_buf }
    for _, client in ipairs(servers_on_buffer) do
      if client.attached_buffers[current_buf] then
        client.stop(force)
      end
    end
  else
    for _, client in ipairs(get_clients_from_cmd_args(server_id)) do
      client.stop(force)
    end
  end
end, {
  desc = 'Manually stops the given language client(s)',
  nargs = '?',
  complete = lsp_get_active_client_ids,
})

api.nvim_create_user_command('LspLog', function()
  vim.cmd(string.format('tabnew %s', lsp.get_log_path()))
end, {
  desc = 'Opens the Nvim LSP client log.',
})

--- Start/stop servers when nvim session looses focus and restart them on demand.
-- This features is motivated by the fact that some servers may gain serious
-- memory footprint and may incur performance issues. Added on May 12, 2023
-- See :h lspconfig-lifecycle
local lspSLifeCycle = vim.g.lspconfigServerLifeCycle
if lspSLifeCycle and type(lspSLifeCycle) == 'table' then
  local defaultTimeOut = 1000 * 60 * 30 -- 30 minutes
  local timeout = lspSLifeCycle.timeout or defaultTimeOut
  vim.api.nvim_create_augroup('lspconfigServerLifeCycle', { clear = true })
  vim.api.nvim_create_autocmd({
    'FocusGained',
  }, {
    pattern = '*',
    group = 'lspconfigServerLifeCycle',
    desc = 'Lspconfig: restart halted lsp servers for given',
    callback = function()
      if _G.nvimLspconfigTimer then
        _G.nvimLspconfigTimer:stop()
        _G.nvimLspconfigTimer:close()
        _G.nvimLspconfigTimer = nil
      end
      if #vim.lsp.get_active_clients() <= 1 then
        vim.cmd 'LspStart'
      end
    end,
  })

  vim.api.nvim_create_autocmd({
    'FocusLost',
  }, {
    pattern = '*',
    group = 'lspconfigServerLifeCycle',
    desc = 'Lspconfig: halt lsp servers when focus is lost',
    callback = function()
      if not _G.nvimLspconfigTimer and #vim.lsp.get_active_clients() > 0 then
        _G.nvimLspconfigTimer = vim.loop.new_timer()
        _G.nvimLspconfigTimer:start(
          timeout,
          0,
          vim.schedule_wrap(function()
            local activeServers = #vim.lsp.get_active_clients()
            vim.cmd 'LspStop'
            vim.notify(
              ('[lspconfig]: nvim has lost focus, stop current language servers. Number of servers left: %s'):format(
                activeServers
              ),
              vim.log.levels.INFO
            )
            _G.nvimLspconfigTimer = nil
          end)
        )
      end
    end,
  })
end
