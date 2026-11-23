---@brief
---
--- https://github.com/clice-io/clice
--- Clice is a next-generation language server for modern C++, focused on performance and code intelligence
---
--- Commands:
--- - `:LspCliceShowContext`, `:LspCliceSwitchContext`, `:LspCliceResetContext`: show, choose or
---   reset the compilation context of the buffer: the source file a header compiles in, or the
---   compile command of a source file listed with several. Showing it also tells where the
---   buffer's command comes from.
--- - `:LspCliceSwitchConfiguration`: select the build configuration (the `configuration` tags of
---   the `clice.toml` rules) and restart clice under it; before Neovim 0.12, from its next start.
--- - `:LspCliceSwitchSourceHeader`: open the file the buffer pairs with — a header's source, a
---   source's header, a module's interface or implementation — or pick one when several qualify.

---@param client vim.lsp.Client
---@param bufnr integer
---@param method string
---@param params table
---@param on_result fun(result: any)
local function request(client, bufnr, method, params, on_result)
  local sent = client:request(method, params, function(err, result)
    if err then
      vim.notify(('%s: %s'):format(method, err.message), vim.log.levels.ERROR)
    else
      on_result(result)
    end
  end, bufnr)
  if not sent then
    vim.notify(('%s: clice is not running'):format(method), vim.log.levels.ERROR)
  end
end

--- Every page of the buffer's contexts, all from one listing epoch.
---@param client vim.lsp.Client
---@param bufnr integer
---@param on_contexts fun(contexts: table[], epoch: integer)
local function query_contexts(client, bufnr, on_contexts)
  local uri = vim.uri_from_bufnr(bufnr)
  local contexts, epoch = {}, nil
  local function fetch()
    request(client, bufnr, 'clice/queryContext', { uri = uri, offset = #contexts }, function(page)
      if epoch and page.epoch ~= epoch then
        contexts, epoch = {}, nil
        return fetch()
      end
      epoch = page.epoch
      vim.list_extend(contexts, page.contexts)
      if #page.contexts > 0 and #contexts < page.total then
        fetch()
      else
        on_contexts(contexts, epoch)
      end
    end)
  end
  fetch()
end

---@param client vim.lsp.Client
---@param bufnr integer
local function show_context(client, bufnr)
  request(client, bufnr, 'clice/currentContext', { uri = vim.uri_from_bufnr(bufnr) }, function(current)
    -- Where the command comes from: database, host, default, borrowed or fallback.
    local command = current.command
    local source = ''
    if command ~= nil and command ~= vim.NIL then
      local from = command.from ~= nil
          and command.from ~= vim.NIL
          and (' from %s'):format(vim.fn.fnamemodify(vim.uri_to_fname(command.from), ':~:.'))
        or ''
      source = ('; its command: %s%s'):format(command.source, from)
    end
    local context = current.context
    if context == nil or context == vim.NIL then
      return vim.notify(('clice: no compilation context for this file%s'):format(source))
    end
    local chosen = current.automatic and 'picked automatically' or 'chosen'
    vim.notify(('clice: %s, %s (%s)%s'):format(context.label, context.description, chosen, source))
  end)
end

---@param client vim.lsp.Client
---@param bufnr integer
local function reset_context(client, bufnr)
  request(client, bufnr, 'clice/resetContext', { uri = vim.uri_from_bufnr(bufnr) }, function() end)
end

---@param client vim.lsp.Client
---@param bufnr integer
local function switch_context(client, bufnr)
  local uri = vim.uri_from_bufnr(bufnr)
  query_contexts(client, bufnr, function(contexts, epoch)
    request(client, bufnr, 'clice/currentContext', { uri = uri }, function(current)
      if current.epoch ~= epoch then
        return switch_context(client, bufnr)
      elseif #contexts == 0 then
        return vim.notify('clice: no compilation contexts for this file')
      end
      local active = current.context ~= vim.NIL and current.context or {}
      if not current.automatic then
        table.insert(contexts, 1, { automatic = true })
      end
      vim.ui.select(contexts, {
        prompt = 'Compilation context',
        format_item = function(item)
          if item.automatic then
            return 'Automatic'
          end
          local same = item.uri == active.uri
            and item.occurrence == active.occurrence
            and item.commandHash == active.commandHash
          return ('%s  %s%s'):format(item.label, item.description, same and ' (in use)' or '')
        end,
      }, function(choice)
        if not choice then
          return
        elseif choice.automatic then
          return reset_context(client, bufnr)
        end
        request(client, bufnr, 'clice/switchContext', {
          uri = uri,
          contextUri = choice.uri,
          occurrence = choice.occurrence,
          commandHash = choice.commandHash,
          epoch = epoch,
        }, function(result)
          if result.stale then
            vim.notify('clice: the contexts changed meanwhile, pick again', vim.log.levels.WARN)
          elseif not result.success then
            vim.notify('clice: failed to switch the compilation context', vim.log.levels.WARN)
          end
        end)
      end)
    end)
  end)
end

---@param client vim.lsp.Client
---@param bufnr integer
local function switch_configuration(client, bufnr)
  local uri = vim.uri_from_bufnr(bufnr)
  request(client, bufnr, 'clice/listConfigurations', { uri = uri }, function(list)
    if #list.configurations == 0 then
      return vim.notify('clice: the rules declare no build configurations')
    end
    local build = list.build ~= vim.NIL and list.build or nil
    vim.ui.select(list.configurations, {
      prompt = 'Build configuration',
      format_item = function(name)
        local notes = {}
        if name == list.active then
          table.insert(notes, 'active')
          if build then
            local directory = vim.fs.dirname(vim.uri_to_fname(build.databases[1]))
            table.insert(notes, 'links to ' .. vim.fn.fnamemodify(directory, ':~:.'))
          end
        elseif name == list.selected then
          table.insert(notes, 'selected for the next start')
        end
        if name == list.defaultConfiguration then
          table.insert(notes, 'default')
        end
        if build and name == build.configuration then
          table.insert(notes, ('the links of %s resolve here'):format(list.active))
        end
        return #notes == 0 and name or ('%s (%s)'):format(name, table.concat(notes, ', '))
      end,
    }, function(name)
      if not name then
        return
      end
      request(client, bufnr, 'clice/switchConfiguration', { name = name, uri = uri }, function(result)
        if not result.success then
          vim.notify(('clice: cannot switch the build configuration: %s'):format(result.reason), vim.log.levels.WARN)
        end
      end)
    end)
  end)
end

---@param client vim.lsp.Client
---@param bufnr integer
local function switch_source_header(client, bufnr)
  request(client, bufnr, 'clice/counterparts', { uri = vim.uri_from_bufnr(bufnr) }, function(result)
    local function open(uri)
      vim.cmd.edit(vim.fn.fnameescape(vim.uri_to_fname(uri)))
    end
    if result.preferred and result.preferred ~= vim.NIL then
      return open(result.preferred)
    elseif #result.candidates == 0 then
      return vim.notify('clice: no counterpart of this file found')
    end
    vim.ui.select(result.candidates, {
      prompt = 'File to open',
      format_item = function(candidate)
        local name = vim.fn.fnamemodify(vim.uri_to_fname(candidate.uri), ':~:.')
        return ('%s  (%s)'):format(name, table.concat(candidate.reasons, ', '))
      end,
    }, function(choice)
      if choice then
        open(choice.uri)
      end
    end)
  end)
end

-- `:lsp restart` (Neovim 0.12) restarts the server when it asks to: what it
-- was started on changed, a configuration file or the build.
local restarts = vim.fn.exists(':lsp') == 2

---@type vim.lsp.Config
return {
  cmd = { 'clice', 'serve' },
  cmd_env = { CLICE_LOG_LEVEL = 'warn' },
  filetypes = { 'c', 'cpp', 'cuda', 'objc', 'objcpp', 'opencl', 'hip' },
  root_markers = { 'clice.toml', 'compile_commands.json', '.git' },
  -- A file below no root marker, such as an installed package's module that go
  -- to definition opens, joins a running clice, a project's rather than one
  -- started for a file alone: the project's database may list the file, and a
  -- clice started for a file alone reads none.
  -- LIMITATION: with several projects open, it joins the first one started.
  reuse_client = function(client, config)
    if client.name ~= config.name or client:is_stopped() then
      return false
    end
    local function serves_project(other)
      return #(other.workspace_folders or {}) > 0
    end
    if not config.root_dir then
      -- `_uninitialized` (internal, what Neovim's own lsp.lua passes) also
      -- lists a project's clice still starting, as in a restored session.
      local running = vim.lsp.get_clients({ name = config.name, _uninitialized = true })
      return serves_project(client) or not vim.iter(running):any(serves_project)
    end
    local root = vim.uri_from_fname(config.root_dir)
    for _, folder in ipairs(client.workspace_folders or {}) do
      if folder.uri == root then
        return true
      end
    end
    return false
  end,
  capabilities = restarts and { experimental = { restartServer = true } } or nil,
  handlers = restarts and {
    ['clice/restartServer'] = function()
      vim.schedule(function()
        vim.cmd('lsp restart clice')
      end)
      return vim.NIL
    end,
  } or nil,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCliceShowContext', function()
      show_context(client, bufnr)
    end, { desc = 'Show the compilation context in use' })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCliceSwitchContext', function()
      switch_context(client, bufnr)
    end, { desc = 'Switch the compilation context' })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCliceResetContext', function()
      reset_context(client, bufnr)
    end, { desc = 'Use the automatic compilation context' })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCliceSwitchConfiguration', function()
      switch_configuration(client, bufnr)
    end, { desc = 'Switch the build configuration' })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCliceSwitchSourceHeader', function()
      switch_source_header(client, bufnr)
    end, { desc = 'Switch between source and header' })
  end,
}
