---@brief
---
--- https://github.com/clice-io/clice
--- Clice is a next-generation language server for modern C++, focused on performance and code intelligence
---
--- Commands:
--- - `:LspCliceShowContext`, `:LspCliceSwitchContext`, `:LspCliceResetContext`: show, choose or
---   reset the compilation context of the buffer: the source file a header compiles in, or the
---   compile command of a source file listed with several.
--- - `:LspCliceSwitchConfiguration`: select the build configuration (the `configuration` tags of
---   the `clice.toml` rules) clice runs from its next start.

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
    local context = current.context
    if context == nil or context == vim.NIL then
      return vim.notify('clice: no compilation context for this file')
    end
    local chosen = current.automatic and 'picked automatically' or 'chosen'
    vim.notify(('clice: %s, %s (%s)'):format(context.label, context.description, chosen))
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
    vim.ui.select(list.configurations, {
      prompt = 'Build configuration',
      format_item = function(name)
        local notes = {}
        if name == list.active then
          table.insert(notes, 'active')
        elseif name == list.selected then
          table.insert(notes, 'selected for the next start')
        end
        if name == list.defaultConfiguration then
          table.insert(notes, 'default')
        end
        return #notes == 0 and name or ('%s (%s)'):format(name, table.concat(notes, ', '))
      end,
    }, function(name)
      if not name then
        return
      end
      request(client, bufnr, 'clice/switchConfiguration', { name = name, uri = uri }, function(result)
        if not result.success then
          vim.notify('clice: failed to switch the build configuration', vim.log.levels.WARN)
        elseif name ~= list.active then
          vim.notify(('clice: %s applies once clice restarts'):format(name))
        end
      end)
    end)
  end)
end

---@type vim.lsp.Config
return {
  cmd = { 'clice', 'serve' },
  filetypes = { 'c', 'cpp', 'cuda' },
  root_markers = { 'clice.toml', 'compile_commands.json', '.git' },
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
  end,
}
