---@brief
---
--- https://github.com/julia-vscode/julia-vscode
---
--- LanguageServer.jl can be installed with `julia` and `Pkg`:
--- ```sh
--- julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'
--- ```
--- where `~/.julia/environments/nvim-lspconfig` is the location where
--- the default configuration expects LanguageServer.jl to be installed.
---
--- To update an existing install, use the following command:
--- ```sh
--- julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.update()'
--- ```
---
--- Note: In order to have LanguageServer.jl pick up installed packages or dependencies in a
--- Julia project, you must make sure that the project is instantiated:
--- ```sh
--- julia --project=/path/to/my/project -e 'using Pkg; Pkg.instantiate()'
--- ```
---
--- Note: The julia programming language searches for global environments within the `environments/`
--- folder of `$JULIA_DEPOT_PATH` entries. By default this simply `~/.julia/environments`

local root_files = { 'Project.toml', 'JuliaProject.toml' }

local function activate_env(path)
  assert(vim.fn.has 'nvim-0.10' == 1, 'requires Nvim 0.10 or newer')
  local bufnr = vim.api.nvim_get_current_buf()
  local julials_clients = vim.lsp.get_clients { bufnr = bufnr, name = 'julials' }
  assert(
    #julials_clients > 0,
    'method julia/activateenvironment is not supported by any servers active on the current buffer'
  )
  local function _activate_env(environment)
    if environment then
      for _, julials_client in ipairs(julials_clients) do
        julials_client:notify('julia/activateenvironment', { envPath = environment })
      end
      vim.notify('Julia environment activated: \n`' .. environment .. '`', vim.log.levels.INFO)
    end
  end
  if path then
    path = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(path), ':p'))
    local found_env = false
    for _, project_file in ipairs(root_files) do
      local file = vim.uv.fs_stat(vim.fs.joinpath(path, project_file))
      if file and file.type then
        found_env = true
        break
      end
    end
    if not found_env then
      vim.notify('Path is not a julia environment: \n`' .. path .. '`', vim.log.levels.WARN)
      return
    end
    _activate_env(path)
  else
    local depot_paths = vim.env.JULIA_DEPOT_PATH
        and vim.split(vim.env.JULIA_DEPOT_PATH, vim.fn.has 'win32' == 1 and ';' or ':')
      or { vim.fn.expand '~/.julia' }
    local environments = {}
    vim.list_extend(environments, vim.fs.find(root_files, { type = 'file', upward = true, limit = math.huge }))
    for _, depot_path in ipairs(depot_paths) do
      local depot_env = vim.fs.joinpath(vim.fs.normalize(depot_path), 'environments')
      vim.list_extend(
        environments,
        vim.fs.find(function(name, env_path)
          return vim.tbl_contains(root_files, name) and string.sub(env_path, #depot_env + 1):match '^/[^/]*$'
        end, { path = depot_env, type = 'file', limit = math.huge })
      )
    end
    environments = vim.tbl_map(vim.fs.dirname, environments)
    vim.ui.select(environments, { prompt = 'Select a Julia environment' }, _activate_env)
  end
end

local cmd = {
  'julia',
  '--startup-file=no',
  '--history-file=no',
  '-e',
  [[
    # Load LanguageServer.jl: attempt to load from ~/.julia/environments/nvim-lspconfig
    # with the regular load path as a fallback
    ls_install_path = joinpath(
        get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")),
        "environments", "nvim-lspconfig"
    )
    pushfirst!(LOAD_PATH, ls_install_path)
    using LanguageServer
    popfirst!(LOAD_PATH)
    depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
    project_path = let
        dirname(something(
            ## 1. Finds an explicitly set project (JULIA_PROJECT)
            Base.load_path_expand((
                p = get(ENV, "JULIA_PROJECT", nothing);
                p === nothing ? nothing : isempty(p) ? nothing : p
            )),
            ## 2. Look for a Project.toml file in the current working directory,
            ##    or parent directories, with $HOME as an upper boundary
            Base.current_project(),
            ## 3. First entry in the load path
            get(Base.load_path(), 1, nothing),
            ## 4. Fallback to default global environment,
            ##    this is more or less unreachable
            Base.load_path_expand("@v#.#"),
        ))
    end
    @info "Running language server" VERSION pwd() project_path depot_path
    server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
    server.runlinter = true
    run(server)
  ]],
}

return {
  cmd = cmd,
  filetypes = { 'julia' },
  root_markers = root_files,
  on_attach = function()
    vim.api.nvim_buf_create_user_command(0, 'LspJuliaActivateEnv', activate_env, {
      desc = 'Activate a Julia environment',
      nargs = '?',
      complete = 'file',
    })
  end,
}
