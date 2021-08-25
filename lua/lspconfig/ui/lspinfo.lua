local configs = require 'lspconfig/configs'
local windows = require 'lspconfig/ui/windows'
local util = require 'lspconfig/util'

local indent = '  '
local cmd_not_found_msg = 'False. Please check your path and ensure the server is installed'

local function trim_whitespace(cmd)
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
  cmd = trim_whitespace(cmd)
  cmd = table.concat(cmd, ' ')
  cmd = vim.split(cmd, '\n')
  cmd = trim_whitespace(cmd)
  cmd = table.concat(cmd, ' ')
  return cmd
end

local function autostart_to_str(autostart)
  local autostart_status = 'true'
  if autostart == false then
    autostart_status = 'false'
  end
  return autostart_status
end

local function make_config_info(config)
  local config_info = {}
  config_info.name = config.name
  if config.cmd then
    config_info.cmd = remove_newlines(config.cmd)
    if vim.fn.executable(config.cmd[1]) == 1 then
      config_info.cmd_is_executable = 'true'
    else
      config_info.cmd_is_executable = cmd_not_found_msg
    end
    config_info.cmd = config.cmd[1]
    config_info.cmd_args = '[' .. table.concat(vim.list_slice(config.cmd, 2, #config.cmd), ', ') .. ']'
  else
    config_info.cmd = 'cmd not defined'
    config_info.cmd_is_executable = 'NA'
    config_info.cmd_args = 'NA'
  end
  local buffer_dir = vim.fn.expand '%:p:h'
  config_info.root_dir = config.get_root_dir(buffer_dir) or 'NA'
  config_info.autostart = autostart_to_str(config._autostart)
  config_info.handlers = table.concat(vim.tbl_keys(config.handlers), ', ')
  config_info.filetypes = '[' .. table.concat(config.filetypes or {}, ', ') .. ']'

  local lines = {
    '',
    'Config: ' .. config_info.name,
    '\tfiletypes:         ' .. config_info.filetypes,
    '\troot directory:    ' .. config_info.root_dir,
    '\tcommand:           ' .. config_info.cmd,
    '\targ[s]:            ' .. config_info.cmd_args,
    '\tcmd is executable: ' .. config_info.cmd_is_executable,
    '\tautostart:         ' .. config_info.autostart,
    '\tcustom handlers:   ' .. config_info.handlers,
  }
  return lines
end

local function get_other_matching_providers(filetype)
  local active_clients_list = util.get_active_client_by_ft(filetype)
  local other_matching_configs = {}
  for _, config in pairs(configs) do
    if not vim.tbl_contains(active_clients_list, config.name) then
      table.insert(other_matching_configs, config)
    end
  end
  return other_matching_configs
end

local function make_client_info(client)
  local client_info = {}

  client_info.cmd = client.config.cmd[1]
  client_info.cmd_args = '[' .. table.concat(vim.list_slice(client.config.cmd, 2, #client.config.cmd), ', ') .. ']'
  client_info.root_dir = client.workspaceFolders[1].name
  client_info.filetypes = table.concat(client.config.filetypes or {}, ', ')
  client_info.autostart = autostart_to_str(client._autostart)

  local lines = {
    '',
    'Client: ' .. client.name .. ' (id: ' .. tostring(client.id) .. ' pid: ' .. tostring(client.rpc.pid) .. ')',
    '\tfiletypes:       ' .. client_info.filetypes,
    '\tautostart:       ' .. client_info.autostart,
    '\troot directory:  ' .. client_info.root_dir,
    '\tcommand:         ' .. client_info.cmd,
    '\targ[s]:          ' .. client_info.cmd_args,
  }
  if client.config.lspinfo then
    local server_specific_info = client.config.lspinfo(client.config)
    server_specific_info = vim.tbl_map(function(val)
      return indent .. '\t' .. val
    end, server_specific_info)
    lines = vim.list_extend(lines, server_specific_info)
  end

  return lines
end

return function()
  -- These options need to be cached before switching to the floating
  -- buffer.
  local buf_clients = vim.lsp.buf_get_clients()
  local clients = vim.lsp.get_active_clients()
  local buffer_filetype = vim.bo.filetype

  local win_info = windows.percentage_range_window(0.8, 0.7)
  local bufnr, win_id = win_info.bufnr, win_info.win_id

  local buf_lines = {}

  local buf_client_names = {}
  for _, client in pairs(buf_clients) do
    table.insert(buf_client_names, client.name)
  end

  local header = {
    '',
    '',
    'Language Server Protocol (LSP) info',
    '',
    'Detected filetype:  ' .. buffer_filetype,
    'Default LSP log:    ' .. (vim.lsp.get_log_path()),
    'Configured servers: ' .. table.concat(vim.tbl_keys(configs), ', '),
    '',
    tostring(#vim.tbl_keys(buf_clients)) .. ' client(s) attached to this buffer: ' .. table.concat(
      buf_client_names,
      ', '
    ),
  }
  vim.list_extend(buf_lines, header)

  local active_section_header = {
    '',
    tostring(#clients) .. ' active client(s): ',
  }
  vim.list_extend(buf_lines, active_section_header)
  for _, client in pairs(clients) do
    local client_info = make_client_info(client)
    vim.list_extend(buf_lines, client_info)
  end

  local matching_config_header = {
    '',
    '',
    'Other clients that match the filetype ' .. buffer_filetype .. ':',
  }

  local all_matching_configs_attached_header = {
    '',
    'All the clients that can be configured for the current buffer filetype are currently active.',
    '',
  }

  local other_matching_configs = get_other_matching_providers(buffer_filetype)

  if vim.tbl_isempty(other_matching_configs) then
    vim.list_extend(buf_lines, all_matching_configs_attached_header)
  else
    vim.list_extend(buf_lines, matching_config_header)
    for _, config in pairs(other_matching_configs) do
      if config.filetypes then
        for _, filetype_match in pairs(config.filetypes) do
          if filetype_match == buffer_filetype then
            vim.list_extend(buf_lines, make_config_info(config))
          end
        end
      else
        local matching_config_info = {
          '',
          'Config: ' .. config.name,
          '\tfiletype: ' .. 'No filetypes defined, please define filetypes in setup().',
        }
        vim.list_extend(buf_lines, matching_config_info)
      end
    end
  end

  local fmt_buf_lines = indent_lines(buf_lines, indent .. indent)

  fmt_buf_lines = vim.lsp.util._trim(fmt_buf_lines, {})

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, fmt_buf_lines)
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  vim.api.nvim_buf_set_option(bufnr, 'filetype', 'lspinfo')

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<esc>', '<cmd>bd<CR>', { noremap = true })
  vim.lsp.util.close_preview_autocmd({ 'BufHidden', 'BufLeave' }, win_id)

  vim.fn.matchadd(
    'Error',
    'No filetypes defined, please define filetypes in setup().\\|' .. 'cmd not defined\\|' .. cmd_not_found_msg
  )
  local configs_pattern = '\\%(' .. table.concat(vim.tbl_keys(configs), '\\|') .. '\\)'

  vim.cmd [[highlight LspInfoIdentifier gui=bold]]
  vim.cmd [[highlight link LspInfoFileTypes Type]]
  vim.cmd [[highlight link LspInfoHeader Identifier]]
  vim.cmd [[let m=matchadd("LspInfoHeader", "Language Server Protocol (LSP) info")]]
  vim.cmd('let m=matchadd("LspInfoFileTypes", " ' .. buffer_filetype .. '$")')
  vim.cmd 'let m=matchadd("string", "true")'
  vim.cmd 'let m=matchadd("error", "false")'
  for _, name in ipairs(buf_client_names) do
    vim.cmd('let m=matchadd("LspInfoIdentifier", "' .. name .. '.*[ ,|\']")')
  end

  vim.cmd('syntax match Title /\\%(Client\\|Config\\):.*\\zs' .. configs_pattern .. '/')
end
