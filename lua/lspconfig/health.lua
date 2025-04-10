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

--- Tries to run `cmd` and kills it if it takes more than `ms` milliseconds.
---
--- This avoids hangs if a command waits for input (especially LSP servers).
---
--- @param cmd string[]
--- @return string? # Command output (stdout+stderr), or `nil` on timeout or nonzero exit.
local function try_get_cmd_output(cmd)
  local out = nil
  local function on_data(_, data, _)
    out = (out or '') .. table.concat(data, '\n')
  end
  local chanid = vim.fn.jobstart(cmd, {
    -- cwd = ?,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = on_data,
    on_stderr = on_data,
  })
  local rv = vim.fn.jobwait({ chanid }, 500)
  vim.fn.jobstop(chanid)
  return rv[1] == 0 and out or nil
end

--- Finds a "x.y.z" version string from the output of `prog` after attempting to invoke it with `--version`, `-v`,
--- `--help`, etc.
---
--- Returns the whole line.
---
--- If a version string is not found, returns the concatenated output.
---
--- @param prog string
local function try_fmt_version(prog)
  local all = nil --- Collected output from all attempts.
  local tried = '' --- Attempted commands.
  for _, v_arg in ipairs { '--version', '-version', 'version', '--help' } do
    local cmd = { prog, v_arg }
    local out = try_get_cmd_output(cmd)
    all = out and ('%s\n%s'):format(all or '', out) or all
    local v_line = out and out:match('[^\r\n]*%d+%.[0-9.]+[^\r\n]*') or nil
    if v_line then
      return ('`%s`'):format(vim.trim(v_line))
    end
    tried = tried .. ('`%s %s`\n'):format(prog, v_arg)
  end

  all = all and vim.trim(all:sub(1, 80):gsub('[\r\n]', ' ')) .. '…' or '?'
  return ('`%s` (Failed to get version) Tried:\n%s'):format(all, tried)
end

--- Prettify a path for presentation.
local function fmtpath(p)
  if vim.startswith(p, 'Running') or vim.startswith(p, 'Not') then
    return p
  end
  local isdir = 0 ~= vim.fn.isdirectory(vim.fn.expand(p))
  local r = vim.fn.fnamemodify(p, ':~')
  -- Force directory path to end with "/".
  -- Bonus: avoids wrong highlighting for "~" (because :checkhealth currently uses ft=help).
  return r .. ((isdir and not r:find('[/\\\\]%s*$')) and '/' or '')
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

--- Builds info displayed by both make_config_info and make_client_info.
local function make_info(config_or_client)
  local info = vim.deepcopy(config_or_client)
  local config = config_or_client.config and config_or_client.config or config_or_client

  if config.cmd then
    info.cmd_desc, info.cmd_is_executable = cmd_type[type(config.cmd)](config)
  else
    info.cmd_desc = 'cmd not defined'
    info.cmd_is_executable = 'NA'
  end

  info.autostart = (config.autostart and 'true') or 'false'
  info.filetypes = table.concat(config.filetypes or {}, ', ')

  local version = type(config.cmd) == 'function' and '? (cmd is a function)' or try_fmt_version(config.cmd[1])
  local info_lines = {
    'filetypes:         ' .. info.filetypes,
    'cmd:               ' .. fmtpath(info.cmd_desc),
    ('%-18s %s'):format('version:', version),
    'executable:        ' .. info.cmd_is_executable,
    'autostart:         ' .. info.autostart,
  }

  return info, info_lines
end

local function make_config_info(config, bufnr)
  local config_info, info_lines = make_info(config)
  config_info.helptags = {}

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
      config_info.root_dir = root_dir
    elseif coroutine.status(co) == 'suspended' then
      config_info.root_dir = error_messages.async_root_dir_function
    else
      config_info.root_dir = error_messages.root_dir_not_found
    end
  else
    config_info.root_dir = error_messages.root_dir_not_found
    vim.list_extend(config_info.helptags, helptags[error_messages.root_dir_not_found])
  end

  local handlers = vim.tbl_keys(config.handlers)
  config_info.handlers = table.concat(handlers, ', ')

  table.insert(info_lines, 1, 'Config: ' .. config_info.name)
  table.insert(info_lines, 'root directory:    ' .. fmtpath(config_info.root_dir))
  if #handlers > 0 then
    table.insert(info_lines, 'custom handlers:   ' .. config_info.handlers)
  end

  if vim.tbl_count(config_info.helptags) > 0 then
    local help = vim.tbl_map(function(helptag)
      return string.format(':h %s', helptag)
    end, config_info.helptags)
    table.insert(info_lines, 'Refer to ' .. table.concat(help, ', ') .. ' for help.')
  end

  return table.concat(info_lines, '\n')
end

---@param client vim.lsp.Client
---@param fname string
local function make_client_info(client, fname)
  local client_info, info_lines = make_info(client)

  local workspace_folders = client.workspace_folders
  fname = vim.fs.normalize(vim.uv.fs_realpath(fname) or fn.fnamemodify(fn.resolve(fname), ':p'))

  if workspace_folders then
    for _, schema in ipairs(workspace_folders) do
      local matched = true
      local root_dir = vim.uv.fs_realpath(schema.name)
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

  client_info.attached_bufs = table.concat(vim.lsp.get_buffers_by_client_id(client.id), ', ')

  info_lines = vim.list_extend({
    ('Client: `%s` (id: %s, bufnr: [%s])'):format(client.name, client.id, client_info.attached_bufs),
    'root directory:    ' .. fmtpath(client_info.root_dir),
  }, info_lines)

  return table.concat(info_lines, '\n')
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

  health.start(('LSP configs active in this buffer (bufnr: %s)'):format(bufnr or '(invalid buffer)'))
  health.info('Language client log: ' .. fmtpath(vim.lsp.get_log_path()))
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
    health.info(('Other clients that match the "%s" filetype:'):format(buffer_filetype))
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

  local function fmt_doc(config)
    local lines = {}
    if not config then
      return lines
    end
    local desc = vim.tbl_get(config, 'config_def', 'docs', 'description')
    if desc then
      lines[#lines + 1] = string.format('%s docs: >markdown', config.name)
      lines[#lines + 1] = ''
      vim.list_extend(lines, vim.split(desc, '\n'))
      lines[#lines + 1] = ''
    end
    return lines
  end

  for _, client in ipairs(buf_clients) do
    local config = require('lspconfig.configs')[client.name]
    health.info(table.concat(fmt_doc(config), '\n'))
  end

  for _, config in ipairs(other_matching_configs) do
    health.info(table.concat(fmt_doc(config), '\n'))
  end
end

function M.check()
  if vim.fn.has('nvim-0.11') == 1 then
    local bufempty = vim.fn.line('$') < 3
    if bufempty then
      -- Infer that `:checkhealth lspconfig` was called directly.
      health.info('`:checkhealth lspconfig` was removed. Use `:checkhealth vim.lsp` instead.')
      vim.deprecate(':checkhealth lspconfig', ':checkhealth vim.lsp', '0.12', 'nvim-lspconfig', false)
    else
      -- Healthcheck was auto-discovered  by `:checkhealth` (no args).
      health.info('Skipped. This healthcheck is redundant with `:checkhealth vim.lsp`.')
    end

    return
  end

  -- XXX: create "q" mapping until :checkhealth has this feature in Nvim stable.
  vim.cmd [[nnoremap <buffer> q <c-w>q]]

  -- XXX: :checkhealth switches to its buffer before invoking the healthcheck(s).
  local orig_bufnr = vim.fn.bufnr('#')
  local buf_clients, other_matching_configs = check_lspconfig(orig_bufnr)
  check_lspdocs(buf_clients, other_matching_configs)
end

return M
