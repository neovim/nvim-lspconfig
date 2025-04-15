--- borrowed some source from: https://github.com/seblj/roslyn.nvim

---@param client vim.lsp.Client
---@param target string
local function on_init_sln(client, target)
  vim.notify("Initializing: " .. target, vim.log.levels.INFO, { title = "roslyn-ls" })
  ---@diagnostic disable-next-line: param-type-mismatch
  client:request("solution/open", {
      solution = vim.uri_from_fname(target),
  },
  function (err, result, context)
  end)
end

---@param client vim.lsp.Client
---@param project_files string[]
local function on_init_project(client, project_files)
  vim.notify("Initializing: projects", vim.log.levels.INFO, { title = "roslyn-ls" })
  ---@diagnostic disable-next-line: param-type-mismatch
  client:request("project/open", {
      projects = vim.tbl_map(function(file)
          return vim.uri_from_fname(file)
      end, project_files),
  },
  function (err, result, context)
  end)
end

local function on_attach(client, bufnr)
  -- enable inlay hints if LSP server supports it
  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr=bufnr })
  end

  -- Set autocommands conditional on server_capabilities
  if client.supports_method("textDocument/documentHighlight") then
    vim.api.nvim_exec2([[
    augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]],
    {output=true})
  end

  -- enable semantic tokens highligting hints
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = true
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)
  -- don't try to find sln or csproj for files from libraries
  -- outside of the project
  if not bufname:match("^/tmp/MetadataAsSource/") then
    -- try find solutions root first
    local root_dir = nil
    root_dir = vim.fs.root(bufnr, function (name, path)
      local match = name:match("%.sln$") ~= nil
      if match then
        local sln_file = vim.fs.joinpath(path, name)
        on_init_sln(client, sln_file)
      end
      return match
    end)

    if not root_dir then
      -- try find solutions root first
      root_dir = vim.fs.root(bufnr, function (name, path)
        local match = name:match("%.csproj$") ~= nil
        if match then
          local csproj_file = vim.fs.joinpath(path, name)
          on_init_project(client, {csproj_file})
        end
        return match
      end)
    end

    assert(root_dir, "no solution and no csproj found")

    client.root_dir = root_dir
  end
end


local function start_roslyn_server(pipe_name)
    vim.system({
      "./Microsoft.CodeAnalysis.LanguageServer",
      -- "dotnet",
      -- "Microsoft.CodeAnalysis.LanguageServer.dll",
      "--logLevel",
      "Trace",
      "--extensionLogDirectory",
      "/var/home/ak/devel/roslyn/logs/",
      "--pipe",
      pipe_name
    },
    { cwd = "/var/home/ak/devel/roslyn/artifacts/LanguageServer/Release/net8.0/linux-x64/" })
    vim.uv.sleep(1500)
end

local function roslyn_handlers()
  return {
        -- ["client/registerCapability"] = function(err, res, ctx)
        --     if not roslyn_config.filewatching then
        --         for _, reg in ipairs(res.registrations) do
        --             if reg.method == "workspace/didChangeWatchedFiles" then
        --                 reg.registerOptions.watchers = {}
        --             end
        --         end
        --     end
        --     return vim.lsp.handlers["client/registerCapability"](err, res, ctx)
        -- end,
        ["workspace/projectInitializationComplete"] = function(_, _, ctx)
            vim.notify("Roslyn project initialization complete", vim.log.levels.INFO, { title = "roslyn.nvim" })

            local buffers = vim.lsp.get_buffers_by_client_id(ctx.client_id)
            for _, buf in ipairs(buffers) do
                vim.lsp.util._refresh("textDocument/diagnostic", { bufnr = buf })
            end

            ---NOTE: This is used by rzls.nvim for init
            vim.api.nvim_exec_autocmds("User", { pattern = "RoslynInitialized", modeline = false })
        end,
        ["workspace/_roslyn_projectHasUnresolvedDependencies"] = function()
            vim.notify("Detected missing dependencies. Run dotnet restore command.", vim.log.levels.ERROR, {
                title = "roslyn.nvim",
            })
            return vim.NIL
        end,
        ["workspace/_roslyn_projectNeedsRestore"] = function(_, result, ctx)
            local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

            ---@diagnostic disable-next-line: param-type-mismatch
            client:request("workspace/_roslyn_restore", result, function(err, response)
                if err then
                    vim.notify(err.message, vim.log.levels.ERROR, { title = "roslyn.nvim" })
                end
                if response then
                    for _, v in ipairs(response) do
                        vim.notify(v.message, vim.log.levels.INFO, { title = "roslyn.nvim" })
                    end
                end
            end)

            return vim.NIL
        end,
        ["razor/provideDynamicFileInfo"] = function(_, _, _)
            vim.notify(
                "Razor is not supported.\nPlease use https://github.com/tris203/rzls.nvim",
                vim.log.levels.WARN,
                { title = "roslyn.nvim" }
            )
            return vim.NIL
        end,
    }
end

---@type vim.lsp.ClientConfig
return {
  name = "roslynlsp",
  offset_encoding = 'utf-8',
  ---@param dispatchers vim.lsp.rpc.Dispatchers
  cmd = function (dispatchers)
    local pipe_name = "/tmp/422df9c8340645ba8966061884b388aa.sock"
    start_roslyn_server(pipe_name)
    return vim.lsp.rpc.connect(pipe_name)(dispatchers)
  end,
  filetypes = { "cs" },
  capabilities = {
      -- HACK: Enable filewatching to later just not watch any files
      -- This is to not make the server watch files and make everything super slow in certain situations
      workspace = {
          didChangeWatchedFiles = {
              dynamicRegistration = true,
              -- enable file watcher capabilities for lsp clients
              relativePatternSupport = true,
          },
      },
      -- HACK: Doesn't show any diagnostics if we do not set this to true
      textDocument = {
          diagnostic = {
              dynamicRegistration = true,
          },
      },
  },
  handlers = roslyn_handlers(),
  on_attach = on_attach,
  -- on_init = function(client, initialize_result)
  --
  --   -- vim.fs.dir(client.root_dir, )
  --   -- local root_dir = nil
  --   -- root_dir = vim.fs.root(0, function (name, _)
  --   --   local match = name:match("%.sln$") ~= nil
  --   --   if match then
  --   --     on_init_sln(client, name)
  --   --   end
  --   --   return match
  --   -- end)
  --   --
  --   -- if not root_dir then
  --   --   -- try find solutions root first
  --   --   root_dir = vim.fs.root(0, function (name, _)
  --   --     local match = name:match("%.csproj$") ~= nil
  --   --     if match then
  --   --       on_init_project(client, {name})
  --   --     end
  --   --     return match
  --   --   end)
  --   -- end
  --
  --   -- local lsp_commands = require("roslyn.lsp_commands")
  --   -- lsp_commands.fix_all_code_action(client)
  --   -- lsp_commands.nested_code_action(client)
  -- end,
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "fullSolution",
      dotnet_compiler_diagnostics_scope = "fullSolution"
    },
    ["csharp|inlay_hints"] = {
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
    ["csharp|symbol_search"] = {
      dotnet_search_reference_assemblies = true
    },
    ["csharp|completion"] = {
      dotnet_show_name_completion_suggestions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_provide_regex_completions = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  }
}

