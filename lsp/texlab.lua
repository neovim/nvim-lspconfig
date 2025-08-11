---@brief
---
--- https://github.com/latex-lsp/texlab
---
--- A completion engine built from scratch for (La)TeX.
---
--- See https://github.com/latex-lsp/texlab/wiki/Configuration for configuration options.
---
--- There are some non standard commands supported, namely:
--- `LspTexlabBuild`, `LspTexlabForward`, `LspTexlabCancelBuild`,
--- `LspTexlabDependencyGraph`, `LspTexlabCleanArtifacts`,
--- `LspTexlabCleanAuxiliary`, `LspTexlabFindEnvironments`,
--- and `LspTexlabChangeEnvironment`.

local function buf_build(client, bufnr)
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  client:request('textDocument/build', params, function(err, result)
    if err then
      error(tostring(err))
    end
    local texlab_build_status = {
      [0] = 'Success',
      [1] = 'Error',
      [2] = 'Failure',
      [3] = 'Cancelled',
    }
    vim.notify('Build ' .. texlab_build_status[result.status], vim.log.levels.INFO)
  end, bufnr)
end

local function buf_search(client, bufnr)
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  client:request('textDocument/forwardSearch', params, function(err, result)
    if err then
      error(tostring(err))
    end
    local texlab_forward_status = {
      [0] = 'Success',
      [1] = 'Error',
      [2] = 'Failure',
      [3] = 'Unconfigured',
    }
    vim.notify('Search ' .. texlab_forward_status[result.status], vim.log.levels.INFO)
  end, bufnr)
end

local function buf_cancel_build(client, bufnr)
  return client:exec_cmd({
    title = 'cancel',
    command = 'texlab.cancelBuild',
  }, { bufnr = bufnr })
end

local function dependency_graph(client)
  client:exec_cmd({ command = 'texlab.showDependencyGraph' }, { bufnr = 0 }, function(err, result)
    if err then
      return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
    end
    vim.notify('The dependency graph has been generated:\n' .. result, vim.log.levels.INFO)
  end)
end

local function command_factory(cmd)
  local cmd_tbl = {
    Auxiliary = 'texlab.cleanAuxiliary',
    Artifacts = 'texlab.cleanArtifacts',
  }
  return function(client, bufnr)
    return client:exec_cmd({
      title = ('clean_%s'):format(cmd),
      command = cmd_tbl[cmd],
      arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
    }, { bufnr = bufnr }, function(err, _)
      if err then
        vim.notify(('Failed to clean %s files: %s'):format(cmd, err.message), vim.log.levels.ERROR)
      else
        vim.notify(('Command %s executed successfully'):format(cmd), vim.log.levels.INFO)
      end
    end)
  end
end

local function buf_find_envs(client, bufnr)
  local win = vim.api.nvim_get_current_win()
  client:exec_cmd({
    command = 'texlab.findEnvironments',
    arguments = { vim.lsp.util.make_position_params(win, client.offset_encoding) },
  }, { bufnr = bufnr }, function(err, result)
    if err then
      return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
    end
    local env_names = {}
    local max_length = 1
    for _, env in ipairs(result) do
      table.insert(env_names, env.name.text)
      max_length = math.max(max_length, string.len(env.name.text))
    end
    for i, name in ipairs(env_names) do
      env_names[i] = string.rep(' ', i - 1) .. name
    end
    vim.lsp.util.open_floating_preview(env_names, '', {
      height = #env_names,
      width = math.max((max_length + #env_names - 1), (string.len 'Environments')),
      focusable = false,
      focus = false,
      title = 'Environments',
    })
  end)
end

local function buf_change_env(client, bufnr)
  local new
  vim.ui.input({ prompt = 'New environment name: ' }, function(input)
    new = input
  end)
  if not new or new == '' then
    return vim.notify('No environment name provided', vim.log.levels.WARN)
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  return client:exec_cmd({
    title = 'change_environment',
    command = 'texlab.changeEnvironment',
    arguments = {
      {
        textDocument = { uri = vim.uri_from_bufnr(bufnr) },
        position = { line = pos[1] - 1, character = pos[2] },
        newName = tostring(new),
      },
    },
  }, { bufnr = bufnr })
end

return {
  cmd = { 'texlab' },
  filetypes = { 'tex', 'plaintex', 'bib' },
  root_markers = { '.git', '.latexmkrc', 'latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml' },
  settings = {
    texlab = {
      rootDirectory = nil,
      build = {
        executable = 'latexmk',
        args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
        onSave = false,
        forwardSearchAfter = false,
      },
      forwardSearch = {
        executable = nil,
        args = {},
      },
      chktex = {
        onOpenAndSave = false,
        onEdit = false,
      },
      diagnosticsDelay = 300,
      latexFormatter = 'latexindent',
      latexindent = {
        ['local'] = nil, -- local is a reserved keyword
        modifyLineBreaks = false,
      },
      bibtexFormatter = 'texlab',
      formatterLineLength = 80,
    },
  },
  ---@param client vim.lsp.Client
  ---@param bufnr integer
  on_attach = function(client, bufnr)
    for _, cmd in ipairs({
      { name = 'TexlabBuild', fn = buf_build, desc = 'Build the current buffer' },
      { name = 'TexlabForward', fn = buf_search, desc = 'Forward search from current position' },
      { name = 'TexlabCancelBuild', fn = buf_cancel_build, desc = 'Cancel the current build' },
      { name = 'TexlabDependencyGraph', fn = dependency_graph, desc = 'Show the dependency graph' },
      { name = 'TexlabCleanArtifacts', fn = command_factory('Artifacts'), desc = 'Clean the artifacts' },
      { name = 'TexlabCleanAuxiliary', fn = command_factory('Auxiliary'), desc = 'Clean the auxiliary files' },
      { name = 'TexlabFindEnvironments', fn = buf_find_envs, desc = 'Find the environments at current position' },
      { name = 'TexlabChangeEnvironment', fn = buf_change_env, desc = 'Change the environment at current position' },
    }) do
      vim.api.nvim_buf_create_user_command(bufnr, 'Lsp' .. cmd.name, function()
        cmd.fn(client, bufnr)
      end, { desc = cmd.desc })
    end
  end,
}
