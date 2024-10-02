local M = {}
local health = require('vim.health')

local api, fn = vim.api, vim.fn
local util = require 'lspconfig.util'

local error_messages = {
  cmd_not_found = 'Unable to find executable. Check your $PATH and ensure the server is installed.',
  no_filetype_defined = 'No filetypes defined. Define filetypes in setup().',
  root_dir_not_found = 'Not found.',
  async_root_dir_function = 'Asynchronous root_dir functions are not supported by `:checkhealth lspconfig`',
}

local helptags = {
  [error_messages.no_filetype_defined] = { 'lspconfig-setup' },
  [error_messages.root_dir_not_found] = { 'lspconfig-root-detection' },
}

local function trim_blankspace(cmd)
  local trimmed_cmd = {}
  for _, str in ipairs(cmd) do
    trimmed_cmd[#trimmed_cmd + 1] = str:match '^%s*(.*)'
  end
  return trimmed_cmd
end

local function remove_newlines(cmd)
  cmd = trim_blankspace(cmd)
  cmd = table.concat(cmd, ' ')
  cmd = vim.split(cmd, '\n')
  cmd = trim_blankspace(cmd)
  cmd = table.concat(cmd, ' ')
  return cmd
end

local cmd_type = {
  ['function'] = function(_)
    return '<function>', 'NA'
  end,
  ['table'] = function(config)
    local cmd = remove_newlines(config.cmd)
    if vim.fn.executable(config.cmd[1]) == 1 then
      return cmd, 'true'
    end
    return cmd, error_messages.cmd_not_found
  end,
}

local function make_config_info(config, bufnr)
  local config_info = {}
  config_info.name = config.name
  config_info.helptags = {}

  if config.cmd then
    config_info.cmd, config_info.cmd_is_executable = cmd_type[type(config.cmd)](config)
  else
    config_info.cmd = 'cmd not defined'
    config_info.cmd_is_executable = 'NA'
  end

  local buffer_dir = api.nvim_buf_call(bufnr, function()
    return vim.fn.expand '%:p:h'
  end)

  if config.get_root_dir then
    local root_dir
    local co = coroutine.create(function()
      local status, err = pcall(function()
        root_dir = config.get_root_dir(buffer_dir)
      end)
      if not status then
        vim.notify(('[lspconfig] unhandled error: %s'):format(tostring(err), vim.log.levels.WARN))
      end
    end)
    coroutine.resume(co)
    if root_dir then
      config_info.root_dir = vim.fn.fnamemodify(root_dir, ':~')
    elseif coroutine.status(co) == 'suspended' then
      config_info.root_dir = error_messages.async_root_dir_function
    else
      config_info.root_dir = error_messages.root_dir_not_found
    end
  else
    config_info.root_dir = error_messages.root_dir_not_found
    vim.list_extend(config_info.helptags, helptags[error_messages.root_dir_not_found])
  end

  config_info.autostart = (config.autostart and 'true') or 'false'
  config_info.handlers = table.concat(vim.tbl_keys(config.handlers), ', ')
  config_info.filetypes = table.concat(config.filetypes or {}, ', ')

  local lines = {
    'Config: ' .. config_info.name,
  }

  local info_lines = {
    'filetypes:         ' .. config_info.filetypes,
    'root directory:    ' .. config_info.root_dir,
    'cmd:               ' .. config_info.cmd,
    'cmd is executable: ' .. config_info.cmd_is_executable,
    'autostart:         ' .. config_info.autostart,
    'custom handlers:   ' .. config_info.handlers,
  }

  if vim.tbl_count(config_info.helptags) > 0 then
    local help = vim.tbl_map(function(helptag)
      return string.format(':h %s', helptag)
    end, config_info.helptags)
    info_lines = vim.list_extend({
      'Refer to ' .. table.concat(help, ', ') .. ' for help.',
    }, info_lines)
  end

  vim.list_extend(lines, info_lines)
  return table.concat(lines, '\n')
end

---@param client vim.lsp.Client
---@param fname string
local function make_client_info(client, fname)
  local client_info = {}

  client_info.cmd = cmd_type[type(client.config.cmd)](client.config)
  local workspace_folders = fn.has 'nvim-0.9' == 1 and client.workspace_folders or client.workspaceFolders
  local uv = vim.uv
  fname = vim.fs.normalize(uv.fs_realpath(fname) or fn.fnamemodify(fn.resolve(fname), ':p'))

  if workspace_folders then
    for _, schema in ipairs(workspace_folders) do
      local matched = true
      local root_dir = vim.fn.fnamemodify(uv.fs_realpath(schema.name), ':~')
      if root_dir == nil or fname:sub(1, root_dir:len()) ~= root_dir then
        matched = false
      end

      if matched then
        client_info.root_dir = schema.name
        break
      end
    end
  end

  if not client_info.root_dir then
    client_info.root_dir = 'Running in single file mode.'
  end
  client_info.filetypes = table.concat(client.config.filetypes or {}, ', ')
  client_info.autostart = (client.config.autostart and 'true') or 'false'
  client_info.attached_buffers_list = table.concat(vim.lsp.get_buffers_by_client_id(client.id), ', ')

  local lines = {
    'Client: '
      .. client.name
      .. ' (id: '
      .. tostring(client.id)
      .. ', bufnr: ['
      .. client_info.attached_buffers_list
      .. '])',
  }

  local info_lines = {
    'filetypes:       ' .. client_info.filetypes,
    'autostart:       ' .. client_info.autostart,
    'root directory:  ' .. client_info.root_dir,
    'cmd:             ' .. client_info.cmd,
  }

  if client.config.lspinfo then
    local server_specific_info = client.config.lspinfo(client.config)
    info_lines = vim.list_extend(info_lines, server_specific_info)
  end

  vim.list_extend(lines, info_lines)

  return table.concat(lines, '\n')
end

local function check_lspconfig(bufnr)
  bufnr = (bufnr and bufnr ~= -1) and bufnr or nil

  health.start('LSP configs active in this session (globally)')
  health.info('Configured servers: ' .. table.concat(util.available_servers(), ', '))
  local deprecated_servers = {}
  for server_name, deprecate in pairs(require('lspconfig').server_aliases()) do
    table.insert(deprecated_servers, ('%s -> %s'):format(server_name, deprecate.to))
  end
  if #deprecated_servers == 0 then
    health.ok('Deprecated servers: (none)')
  else
    health.warn('Deprecated servers: ' .. table.concat(deprecated_servers, ', '))
  end

  local buf_clients = not bufnr and {} or vim.lsp.get_clients { bufnr = bufnr }
  local clients = vim.lsp.get_clients()
  local buffer_filetype = bufnr and vim.fn.getbufvar(bufnr, '&filetype') or '(invalid buffer)'
  local fname = bufnr and api.nvim_buf_get_name(bufnr) or '(invalid buffer)'

  local buf_client_ids = {}
  for _, client in ipairs(buf_clients) do
    buf_client_ids[#buf_client_ids + 1] = client.id
  end

  local other_active_clients = {}
  for _, client in ipairs(clients) do
    if not vim.tbl_contains(buf_client_ids, client.id) then
      other_active_clients[#other_active_clients + 1] = client
    end
  end

  health.start(('LSP configs active in this buffer (id=%s)'):format(bufnr or '(invalid buffer)'))
  health.info('Language client log: ' .. (vim.fn.fnamemodify(vim.lsp.get_log_path(), ':~')))
  health.info(('Detected filetype: `%s`'):format(buffer_filetype))
  health.info(('%d client(s) attached to this buffer'):format(#vim.tbl_keys(buf_clients)))
  for _, client in ipairs(buf_clients) do
    health.info(make_client_info(client, fname))
  end

  if not vim.tbl_isempty(other_active_clients) then
    health.info(('%s active client(s) not attached to this buffer:'):format(#other_active_clients))
    for _, client in ipairs(other_active_clients) do
      health.info(make_client_info(client, fname))
    end
  end

  local other_matching_configs = not bufnr and {} or util.get_other_matching_providers(buffer_filetype)
  if not vim.tbl_isempty(other_matching_configs) then
    health.info(('Other clients that match the "%s" filetype: '):format(buffer_filetype))
    for _, config in ipairs(other_matching_configs) do
      health.info(make_config_info(config, bufnr))
    end
  end

  vim.fn.matchadd(
    'Error',
    error_messages.no_filetype_defined
      .. '.\\|'
      .. 'cmd not defined\\|'
      .. error_messages.cmd_not_found
      .. '\\|'
      .. error_messages.root_dir_not_found
  )

  -- TODO(justimk): enhance :checkhealth's highlighting instead of doing this only for lspconfig.
  vim.cmd [[
    syn keyword String true
    syn keyword Error false
  ]]

  return buf_clients, other_matching_configs
end

local function check_lspdocs(buf_clients, other_matching_configs)
  health.start('Docs for active configs:')

  local lines = {}
  local function append_lines(config)
    if not config then
      return
    end
    local desc = vim.tbl_get(config, 'config_def', 'docs', 'description')
    if desc then
      lines[#lines + 1] = string.format('%s docs: >markdown', config.name)
      lines[#lines + 1] = ''
      vim.list_extend(lines, vim.split(desc, '\n'))
      lines[#lines + 1] = ''
    end
  end

  for _, client in ipairs(buf_clients) do
    local config = require('lspconfig.configs')[client.name]
    append_lines(config)
  end

  for _, config in ipairs(other_matching_configs) do
    append_lines(config)
  end

  health.info(table.concat(lines, '\n'))
end

function M.check()
  -- XXX: :checkhealth switches to its buffer before invoking the healthcheck(s).
  local orig_bufnr = vim.fn.bufnr('#')
  local buf_clients, other_matching_configs = check_lspconfig(orig_bufnr)
  check_lspdocs(buf_clients, other_matching_configs)

  -- XXX: create "q" mapping until :checkhealth has this feature in Nvim stable.
  vim.cmd [[nnoremap <buffer> q <c-w>q]]
end

return M
