if vim.g.lspconfig ~= nil then
  return
end
vim.g.lspconfig = 1

local api, lsp = vim.api, vim.lsp
local util = require('lspconfig.util')

local completion_sort = function(items)
  table.sort(items)
  return items
end

local lsp_complete_configured_servers = function(arg)
  return completion_sort(vim.tbl_filter(function(s)
    return s:sub(1, #arg) == arg
  end, util.available_servers()))
end

local lsp_get_active_clients = function(arg)
  local clients = vim.tbl_map(function(client)
    return ('%s'):format(client.name)
  end, util.get_managed_clients())

  return completion_sort(vim.tbl_filter(function(s)
    return s:sub(1, #arg) == arg
  end, clients))
end

---@return vim.lsp.Client[] clients
local get_clients_from_cmd_args = function(arg)
  local result = {}
  local managed_clients = util.get_managed_clients()
  local clients = {}
  for _, client in pairs(managed_clients) do
    clients[client.name] = client
  end

  local err_msg = ''
  arg = arg:gsub('[%a-_]+', function(name)
    if clients[name] then
      return clients[name].id
    end
    err_msg = err_msg .. ('config "%s" not found\n'):format(name)
    return ''
  end)
  for id in (arg or ''):gmatch '(%d+)' do
    local client = lsp.get_client_by_id(assert(tonumber(id)))
    if client == nil then
      err_msg = err_msg .. ('client id "%s" not found\n'):format(id)
    end
    result[#result + 1] = client
  end

  if err_msg ~= '' then
    vim.notify(('nvim-lspconfig:\n%s'):format(err_msg:sub(1, -2)), vim.log.levels.WARN)
    return result
  end

  if #result == 0 then
    return managed_clients
  end
  return result
end

-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', { desc = 'Alias to `:checkhealth vim.lsp`' })

if vim.version.ge(vim.version(), { 0, 11, 2 }) then
  local complete_client = function(arg)
    return vim
      .iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :filter(function(name)
        return name:sub(1, #arg) == arg
      end)
      :totable()
  end

  local complete_config = function(arg)
    return vim
      .iter(vim.api.nvim_get_runtime_file(('lsp/%s*.lua'):format(arg), true))
      :map(function(path)
        local file_name = path:match('[^/]*.lua$')
        return file_name:sub(0, #file_name - 4)
      end)
      :totable()
  end

  api.nvim_create_user_command('LspStart', function(info)
    if vim.lsp.config[info.args] == nil then
      vim.notify(("Invalid server name '%s'"):format(info.args))
      return
    end

    vim.lsp.enable(info.args)
  end, {
    desc = 'Enable and launch a language server',
    nargs = '?',
    complete = complete_config,
  })

  api.nvim_create_user_command('LspRestart', function(info)
    for _, name in ipairs(info.fargs) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(info.args))
      else
        vim.lsp.enable(name, false)
      end
    end

    local timer = assert(vim.uv.new_timer())
    timer:start(500, 0, function()
      for _, name in ipairs(info.fargs) do
        vim.schedule_wrap(function(x)
          vim.lsp.enable(x)
        end)(name)
      end
    end)
  end, {
    desc = 'Restart the given client(s)',
    nargs = '+',
    complete = complete_client,
  })

  api.nvim_create_user_command('LspStop', function(info)
    for _, name in ipairs(info.fargs) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(info.args))
      else
        vim.lsp.enable(name, false)
      end
    end
  end, {
    desc = 'Disable and stop the given client(s)',
    nargs = '+',
    complete = complete_client,
  })

  return
end

api.nvim_create_user_command('LspStart', function(info)
  local server_name = string.len(info.args) > 0 and info.args or nil
  if server_name then
    local config = require('lspconfig.configs')[server_name]
    if config then
      config.launch()
      return
    end
  end

  local matching_configs = util.get_config_by_ft(vim.bo.filetype)
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
    -- Can remove diagnostic disabling when changing to client:stop() in nvim 0.11+
    --- @diagnostic disable: missing-parameter
    client.stop()
    if vim.tbl_count(client.attached_buffers) > 0 then
      detach_clients[client.name] = { client, lsp.get_buffers_by_client_id(client.id) }
    end
  end
  local timer = assert(vim.uv.new_timer())
  timer:start(
    500,
    100,
    vim.schedule_wrap(function()
      for client_name, tuple in pairs(detach_clients) do
        if require('lspconfig.configs')[client_name] then
          local client, attached_buffers = unpack(tuple)
          if client.is_stopped() then
            for _, buf in pairs(attached_buffers) do
              require('lspconfig.configs')[client_name].launch(buf)
            end
            detach_clients[client_name] = nil
          end
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
  complete = lsp_get_active_clients,
})

api.nvim_create_user_command('LspStop', function(info)
  ---@type string
  local args = info.args
  local force = false
  args = args:gsub('%+%+force', function()
    force = true
    return ''
  end)

  local clients = {}

  -- default to stopping all servers on current buffer
  if #args == 0 then
    clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  else
    clients = get_clients_from_cmd_args(args)
  end

  for _, client in ipairs(clients) do
    -- Can remove diagnostic disabling when changing to client:stop(force) in nvim 0.11+
    --- @diagnostic disable: param-type-mismatch
    client.stop(force)
  end
end, {
  desc = 'Manually stops the given language client(s)',
  nargs = '?',
  complete = lsp_get_active_clients,
})

api.nvim_create_user_command('LspLog', function()
  vim.cmd(string.format('tabnew %s', lsp.get_log_path()))
end, {
  desc = 'Opens the Nvim LSP client log.',
})
