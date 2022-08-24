local api = vim.api
local configs = require 'lspconfig.configs'
local windows = require 'lspconfig.ui.windows'
local util = require 'lspconfig.util'

local error_messages = {
  cmd_not_found = 'Unable to find executable. Please check your path and ensure the server is installed',
  no_filetype_defined = 'No filetypes defined, Please define filetypes in setup()',
  root_dir_not_found = 'Not found.',
}

local helptags = {
  [error_messages.no_filetype_defined] = { 'lspconfig-setup' },
  [error_messages.root_dir_not_found] = { 'lspconfig-root-detection' },
}

local function trim_blankspace(cmd)
  local trimmed_cmd = {}
  for _, str in pairs(cmd) do
    table.insert(trimmed_cmd, str:match '^%s*(.*)')
  end
  return trimmed_cmd
end

local function indent_lines(lines, offset)
  return vim.tbl_map(function(val)
    return offset .. val
  end, lines)
end

local function remove_newlines(cmd)
  cmd = trim_blankspace(cmd)
  cmd = table.concat(cmd, ' ')
  cmd = vim.split(cmd, '\n')
  cmd = trim_blankspace(cmd)
  cmd = table.concat(cmd, ' ')
  return cmd
end

local function make_config_info(config, bufnr)
  local config_info = {}
  config_info.name = config.name
  config_info.helptags = {}
  if config.cmd then
    config_info.cmd = remove_newlines(config.cmd)
    if vim.fn.executable(config.cmd[1]) == 1 then
      config_info.cmd_is_executable = 'true'
    else
      config_info.cmd_is_executable = error_messages.cmd_not_found
    end
  else
    config_info.cmd = 'cmd not defined'
    config_info.cmd_is_executable = 'NA'
  end

  local buffer_dir = api.nvim_buf_call(bufnr, function()
    return vim.fn.expand '%:p:h'
  end)
  local root_dir = config.get_root_dir(buffer_dir)
  if root_dir then
    config_info.root_dir = root_dir
  else
    config_info.root_dir = error_messages.root_dir_not_found
    vim.list_extend(config_info.helptags, helptags[error_messages.root_dir_not_found])
    local root_dir_pattern = vim.tbl_get(config, 'document_config', 'docs', 'default_config', 'root_dir')
    if root_dir_pattern then
      config_info.root_dir = config_info.root_dir
        .. ' Searched for: '
        .. remove_newlines(vim.split(root_dir_pattern, '\n'))
        .. '.'
    end
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

  vim.list_extend(lines, indent_lines(info_lines, '\t'))

  return lines
end

local function make_client_info(client)
  local client_info = {}

  client_info.cmd = remove_newlines(client.config.cmd)
  if client.workspaceFolders then
    client_info.root_dir = client.workspaceFolders[1].name
  else
    client_info.root_dir = 'Running in single file mode.'
  end
  client_info.filetypes = table.concat(client.config.filetypes or {}, ', ')
  client_info.autostart = (client.config.autostart and 'true') or 'false'
  client_info.attached_buffers_list = table.concat(vim.lsp.get_buffers_by_client_id(client.id), ', ')

  local lines = {
    '',
    'Client: '
      .. client.name
      .. ' (id: '
      .. tostring(client.id)
      .. ', pid: '
      .. tostring(client.rpc.pid)
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

  vim.list_extend(lines, indent_lines(info_lines, '\t'))

  return lines
end

--- if the server lists length longer than window it should be show in a
--- new line
--- | LspInfo window                                       | --out of window
--- | Configured servers list:  server_name, server_name1, | server_name2
--- |                           server_name3, server_name4,| --new change
---@private
local function generate_servers_list(servers_ctx)
  local header, servers, width = servers_ctx.header, servers_ctx.servers, servers_ctx.width
  local lines, hi_scope = {}, {}
  local space = ' '
  local server_name_sep = ',' .. space
  local length, start_index, _end_index = #header, 1, 0

  for i = 1, #servers do
    local next_index = i == #servers and i or i + 1
    -- check the lines is empty or not
    local header_empty = next(lines) == nil and true or false
    length = length + #server_name_sep + #servers[i]
    table.insert(hi_scope, { length - #server_name_sep - #servers[i], length - #server_name_sep })

    if (length + #servers[next_index]) > width or length == width then
      _end_index = i
    end

    -- when the index is last one and still has the server names not insert
    if i == #servers and length ~= 0 then
      _end_index = i
    end

    if _end_index > 0 then
      local names = table.concat(servers, server_name_sep, start_index, _end_index)
      names = header_empty and header .. names or space:rep(#header) .. names
      table.insert(lines, space)
      table.insert(lines, names)
      length = #header
      start_index = i + 1
      _end_index = 0
    end
  end

  return lines, hi_scope
end

return function()
  -- These options need to be cached before switching to the floating
  -- buffer.
  local buf_clients = vim.lsp.buf_get_clients()
  local clients = vim.lsp.get_active_clients()
  local buffer_filetype = vim.bo.filetype
  local original_bufnr = api.nvim_get_current_buf()

  local win_info = windows.percentage_range_window(0.8, 0.7)
  local bufnr, win_id = win_info.bufnr, win_info.win_id
  -- float window width
  local floating_width = win_info.opts.width

  local buf_lines = {}

  local buf_client_ids = {}
  for _, client in pairs(buf_clients) do
    table.insert(buf_client_ids, client.id)
  end

  local other_active_clients = {}
  for _, client in pairs(clients) do
    if not vim.tbl_contains(buf_client_ids, client.id) then
      table.insert(other_active_clients, client)
    end
  end

  local header = {
    '',
    'Language client log: ' .. (vim.lsp.get_log_path()),
    'Detected filetype:   ' .. buffer_filetype,
  }
  vim.list_extend(buf_lines, header)

  local buffer_clients_header = {
    '',
    tostring(#vim.tbl_keys(buf_clients)) .. ' client(s) attached to this buffer: ',
  }

  vim.list_extend(buf_lines, buffer_clients_header)
  for _, client in pairs(buf_clients) do
    local client_info = make_client_info(client)
    vim.list_extend(buf_lines, client_info)
  end

  local other_active_section_header = {
    '',
    tostring(#other_active_clients) .. ' active client(s) not attached to this buffer: ',
  }
  if not vim.tbl_isempty(other_active_clients) then
    vim.list_extend(buf_lines, other_active_section_header)
  end
  for _, client in pairs(other_active_clients) do
    local client_info = make_client_info(client)
    vim.list_extend(buf_lines, client_info)
  end

  local other_matching_configs_header = {
    '',
    'Other clients that match the filetype: ' .. buffer_filetype,
    '',
  }

  local other_matching_configs = util.get_other_matching_providers(buffer_filetype)

  if not vim.tbl_isempty(other_matching_configs) then
    vim.list_extend(buf_lines, other_matching_configs_header)
    for _, config in pairs(other_matching_configs) do
      vim.list_extend(buf_lines, make_config_info(config, original_bufnr))
    end
  end

  local configured_head = 'Configured servers list: '
  local start_row = #buf_lines
  local servers_ctx = {
    servers = vim.tbl_keys(configs),
    width = floating_width,
    header = configured_head,
  }
  local servers_list, hi_scope = generate_servers_list(servers_ctx)

  vim.list_extend(buf_lines, servers_list)

  local fmt_buf_lines = indent_lines(buf_lines, ' ')

  fmt_buf_lines = vim.lsp.util._trim(fmt_buf_lines, {})

  api.nvim_buf_set_lines(bufnr, 0, -1, true, fmt_buf_lines)
  api.nvim_buf_set_option(bufnr, 'modifiable', false)
  api.nvim_buf_set_option(bufnr, 'filetype', 'lspinfo')

  api.nvim_buf_attach(bufnr, false, {
    on_detach = function()
      if api.nvim_win_is_valid(win_id) then
        api.nvim_win_close(win_id, true)
      end
    end,
  })

  vim.keymap.set('n', '<ESC>', function()
    if api.nvim_buf_is_valid(bufnr) then
      api.nvim_buf_delete(bufnr, { force = true })
    end
  end, { buffer = bufnr, nowait = true })

  local au_id
  au_id = api.nvim_create_autocmd({ 'BufLeave,BufHidden' }, {
    once = true,
    buffer = bufnr,
    callback = function()
      if api.nvim_win_is_valid(win_id) then
        api.nvim_win_close(win_id, true)
      end

      if au_id then
        pcall(api.nvim_del_autocmd, au_id)
      end
    end,
  })

  vim.fn.matchadd(
    'Error',
    error_messages.no_filetype_defined
      .. '.\\|'
      .. 'cmd not defined\\|'
      .. error_messages.cmd_not_found
      .. '\\|'
      .. error_messages.root_dir_not_found
  )

  vim.cmd 'let m=matchadd("string", "true")'
  vim.cmd 'let m=matchadd("error", "false")'
  for _, config in pairs(configs) do
    vim.fn.matchadd('Title', '\\%(Client\\|Config\\):.*\\zs' .. config.name .. '\\ze')
    if config.filetypes then
      for _, ft in pairs(config.filetypes) do
        vim.fn.matchadd('Type', '\\%(filetypes\\|filetype\\):.*\\zs' .. ft .. '\\ze')
      end
    end
  end

  for i, scope in pairs(hi_scope) do
    local start_col, end_col = unpack(scope)
    if start_col == #configured_head then
      start_row = i == 1 and start_row + 1 or start_row + 2
    end

    api.nvim_buf_add_highlight(bufnr, 0, 'LspInfoList', start_row, start_col + 1, end_col + 1)
  end
end
