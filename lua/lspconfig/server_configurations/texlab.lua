local util = require 'lspconfig.util'

local texlab_build_status = {
  [0] = 'Success',
  [1] = 'Error',
  [2] = 'Failure',
  [3] = 'Cancelled',
}

local texlab_forward_status = {
  [0] = 'Success',
  [1] = 'Error',
  [2] = 'Failure',
  [3] = 'Unconfigured',
}

local function buf_build(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  local pos = vim.api.nvim_win_get_cursor(0)
  local params = {
    textDocument = { uri = vim.uri_from_bufnr(bufnr) },
    position = { line = pos[1] - 1, character = pos[2] },
  }
  if texlab_client then
    texlab_client.request('textDocument/build', params, function(err, result)
      if err then
        error(tostring(err))
      end
      vim.notify('Build ' .. texlab_build_status[result.status], vim.log.levels.INFO)
    end, bufnr)
  else
    vim.notify(
      'method textDocument/build is not supported by any servers active on the current buffer',
      vim.log.levels.WARN
    )
  end
end

local function buf_search(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  local pos = vim.api.nvim_win_get_cursor(0)
  local params = {
    textDocument = { uri = vim.uri_from_bufnr(bufnr) },
    position = { line = pos[1] - 1, character = pos[2] },
  }
  if texlab_client then
    texlab_client.request('textDocument/forwardSearch', params, function(err, result)
      if err then
        error(tostring(err))
      end
      vim.notify('Search ' .. texlab_forward_status[result.status], vim.log.levels.INFO)
    end, bufnr)
  else
    vim.notify(
      'method textDocument/forwardSearch is not supported by any servers active on the current buffer',
      vim.log.levels.WARN
    )
  end
end

local function buf_cancel_build(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  if not util.get_active_client_by_name(bufnr, 'texlab') then
    return vim.notify('Texlab client not found', vim.log.levels.ERROR)
  end
  vim.lsp.buf.execute_command { command = 'texlab.cancelBuild' }
  vim.notify('Build cancelled', vim.log.levels.INFO)
end

local function dependency_graph(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if not texlab_client then
    return vim.notify('Texlab client not found', vim.log.levels.ERROR)
  end
  texlab_client.request('workspace/executeCommand', { command = 'texlab.showDependencyGraph' }, function(err, result)
    if err then
      return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
    end
    vim.notify('The dependency graph has been generated:\n' .. result, vim.log.levels.INFO)
  end, 0)
end

local function cleanArtifacts(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  if not util.get_active_client_by_name(bufnr, 'texlab') then
    return vim.notify('Texlab client not found', vim.log.levels.ERROR)
  end
  vim.lsp.buf.execute_command {
    command = 'texlab.cleanArtifacts',
    arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
  }
  vim.notify('Artifacts cleaned successfully', vim.log.levels.INFO)
end

local function cleanAuxiliary(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  if not util.get_active_client_by_name(bufnr, 'texlab') then
    return vim.notify('Texlab client not found', vim.log.levels.ERROR)
  end
  vim.lsp.buf.execute_command {
    command = 'texlab.cleanAuxiliary',
    arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
  }
  vim.notify('Auxiliary files cleaned successfully', vim.log.levels.INFO)
end

local function buf_find_envs(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if not texlab_client then
    return vim.notify('Texlab client not found', vim.log.levels.ERROR)
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  texlab_client.request('workspace/executeCommand', {
    command = 'texlab.findEnvironments',
    arguments = {
      {
        textDocument = { uri = vim.uri_from_bufnr(bufnr) },
        position = { line = pos[1] - 1, character = pos[2] },
      },
    },
  }, function(err, result)
    if err then
      return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
    end
    return vim.notify('The environments are:\n' .. vim.inspect(result), vim.log.levels.INFO)
  end, bufnr)
end

local function buf_change_env(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  if not util.get_active_client_by_name(bufnr, 'texlab') then
    return vim.notify('Texlab client not found', vim.log.levels.ERROR)
  end
  local new = vim.fn.input 'Enter the new environment name: '
  if not new or new == '' then
    return vim.notify('No environment name provided', vim.log.levels.WARN)
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.lsp.buf.execute_command {
    command = 'texlab.changeEnvironment',
    arguments = {
      {
        textDocument = { uri = vim.uri_from_bufnr(bufnr) },
        position = { line = pos[1] - 1, character = pos[2] },
        newName = tostring(new),
      },
    },
  }
end

-- bufnr isn't actually required here, but we need a valid buffer in order to
-- be able to find the client for buf_request.
-- TODO find a client by looking through buffers for a valid client?
-- local function build_cancel_all(bufnr)
--   bufnr = util.validate_bufnr(bufnr)
--   local params = { token = "texlab-build-*" }
--   lsp.buf_request(bufnr, 'window/progress/cancel', params, function(err, method, result, client_id)
--     if err then error(tostring(err)) end
--     print("Cancel result", vim.inspect(result))
--   end)
-- end

return {
  default_config = {
    cmd = { 'texlab' },
    filetypes = { 'tex', 'plaintex', 'bib' },
    root_dir = util.root_pattern('.git', '.latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml'),
    single_file_support = true,
    settings = {
      texlab = {
        rootDirectory = nil,
        build = {
          executable = 'latexmk',
          args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
          onSave = false,
          forwardSearchAfter = false,
        },
        auxDirectory = '.',
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
  },
  commands = {
    TexlabBuild = {
      function()
        buf_build(0)
      end,
      description = 'Build the current buffer',
    },
    TexlabForward = {
      function()
        buf_search(0)
      end,
      description = 'Forward search from current position',
    },
    TexlabCancelBuild = {
      function()
        buf_cancel_build(0)
      end,
      description = 'Cancel the current build',
    },
    TexlabDependencyGraph = {
      function()
        dependency_graph(0)
      end,
      description = 'Show the dependency graph',
    },
    TexlabCleanArtifacts = {
      function()
        cleanArtifacts(0)
      end,
      description = 'Clean the artifacts',
    },
    TexlabCleanAuxiliary = {
      function()
        cleanAuxiliary(0)
      end,
      description = 'Clean the auxiliary files',
    },
    TexlabFindEnvironments = {
      function()
        buf_find_envs(0)
      end,
      description = 'Find the environments at current position',
    },
    TexlabChangeEnvironment = {
      function()
        buf_change_env(0)
      end,
      description = 'Change the environment at current position',
    },
  },
  docs = {
    description = [[
https://github.com/latex-lsp/texlab

A completion engine built from scratch for (La)TeX.

See https://github.com/latex-lsp/texlab/wiki/Configuration for configuration options.
]],
  },
}
