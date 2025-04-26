---@brief
---
--- https://github.com/dotnet/roslyn
--
-- To install the server, compile from source or download as nuget package.
-- Go to `https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.<platform>/overview`
-- replace `<platform>` with one of the following `linux-x64`, `osx-x64`, `win-x64`, `neutral` (for more info on the download location see https://github.com/dotnet/roslyn/issues/71474#issuecomment-2177303207).
-- Download and extract it (nuget's are zip files).
-- - if you chose `neutral` nuget version, then you have to change the `cmd` like so:
--   cmd = {
--     'dotnet',
--     '<my_folder>/Microsoft.CodeAnalysis.LanguageServer.dll',
--     '--logLevel', -- this property is required by the server
--     'Information',
--     '--extensionLogDirectory', -- this property is required by the server
--     fs.joinpath(uv.os_tmpdir(), 'roslyn_ls/logs'),
--     '--stdio',
--   },
--   where `<my_folder>` has to be the folder you extracted the nuget package to.
-- - for all other platforms put the extracted folder to neovim's PATH (`vim.env.PATH`)

local uv = vim.uv
local fs = vim.fs

---@param client vim.lsp.Client
---@param target string
local function on_init_sln(client, target)
  vim.notify('Initializing: ' .. target, vim.log.levels.INFO, { title = 'roslyn_ls' })
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify('solution/open', {
    solution = vim.uri_from_fname(target),
  })
end

---@param client vim.lsp.Client
---@param project_files string[]
local function on_init_project(client, project_files)
  vim.notify('Initializing: projects', vim.log.levels.INFO, { title = 'roslyn_ls' })
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify('project/open', {
    projects = vim.tbl_map(function(file)
      return vim.uri_from_fname(file)
    end, project_files),
  })
end

local function roslyn_handlers()
  return {
    ['workspace/projectInitializationComplete'] = function(_, _, ctx)
      vim.notify('Roslyn project initialization complete', vim.log.levels.INFO, { title = 'roslyn_ls' })

      local buffers = vim.lsp.get_buffers_by_client_id(ctx.client_id)
      for _, buf in ipairs(buffers) do
        vim.lsp.util._refresh('textDocument/diagnostic', { bufnr = buf })
      end
    end,
    ['workspace/_roslyn_projectHasUnresolvedDependencies'] = function()
      vim.notify('Detected missing dependencies. Run `dotnet restore` command.', vim.log.levels.ERROR, {
        title = 'roslyn_ls',
      })
      return vim.NIL
    end,
    ['workspace/_roslyn_projectNeedsRestore'] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

      ---@diagnostic disable-next-line: param-type-mismatch
      client:request('workspace/_roslyn_restore', result, function(err, response)
        if err then
          vim.notify(err.message, vim.log.levels.ERROR, { title = 'roslyn_ls' })
        end
        if response then
          for _, v in ipairs(response) do
            vim.notify(v.message, vim.log.levels.INFO, { title = 'roslyn_ls' })
          end
        end
      end)

      return vim.NIL
    end,
    ['razor/provideDynamicFileInfo'] = function(_, _, _)
      vim.notify(
        'Razor is not supported.\nPlease use https://github.com/tris203/rzls.nvim',
        vim.log.levels.WARN,
        { title = 'roslyn_ls' }
      )
      return vim.NIL
    end,
  }
end

---@type vim.lsp.ClientConfig
return {
  name = 'roslyn_ls',
  offset_encoding = 'utf-8',
  cmd = {
    'Microsoft.CodeAnalysis.LanguageServer',
    '--logLevel',
    'Information',
    '--extensionLogDirectory',
    fs.joinpath(uv.os_tmpdir(), 'roslyn_ls/logs'),
    '--stdio',
  },
  filetypes = { 'cs' },
  handlers = roslyn_handlers(),
  root_dir = function(bufnr, cb)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    -- don't try to find sln or csproj for files from libraries
    -- outside of the project
    if not bufname:match('^' .. fs.joinpath('/tmp/MetadataAsSource/')) then
      -- try find solutions root first
      local root_dir = fs.root(bufnr, function(fname, _)
        return fname:match('%.sln$') ~= nil
      end)

      if not root_dir then
        -- try find projects root
        root_dir = fs.root(bufnr, function(fname, _)
          return fname:match('%.csproj$') ~= nil
        end)
      end

      if root_dir then
        cb(root_dir)
      end
    end
  end,
  on_init = {
    function(client)
      local root_dir = client.config.root_dir

      -- try load first solution we find
      for entry, type in fs.dir(root_dir) do
        if type == 'file' and vim.endswith(entry, '.sln') then
          on_init_sln(client, fs.joinpath(root_dir, entry))
          return
        end
      end

      -- if no solution is found load project
      for entry, type in fs.dir(root_dir) do
        if type == 'file' and vim.endswith(entry, '.csproj') then
          on_init_project(client, { fs.joinpath(root_dir, entry) })
        end
      end
    end,
  },
  capabilities = {
    -- HACK: Doesn't show any diagnostics if we do not set this to true
    textDocument = {
      diagnostic = {
        dynamicRegistration = true,
      },
    },
  },
  settings = {
    ['csharp|background_analysis'] = {
      dotnet_analyzer_diagnostics_scope = 'fullSolution',
      dotnet_compiler_diagnostics_scope = 'fullSolution',
    },
    ['csharp|inlay_hints'] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_indexer_parameters = true,
      dotnet_enable_inlay_hints_for_literal_parameters = true,
      dotnet_enable_inlay_hints_for_object_creation_parameters = true,
      dotnet_enable_inlay_hints_for_other_parameters = true,
      dotnet_enable_inlay_hints_for_parameters = true,
      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
    },
    ['csharp|symbol_search'] = {
      dotnet_search_reference_assemblies = true,
    },
    ['csharp|completion'] = {
      dotnet_show_name_completion_suggestions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_provide_regex_completions = true,
    },
    ['csharp|code_lens'] = {
      dotnet_enable_references_code_lens = true,
    },
  },
}
