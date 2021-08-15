local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local cmd = {
  'julia',
  '--startup-file=no',
  '--history-file=no',
  '-e',
  [[
    using Pkg
    Pkg.instantiate()
    using LanguageServer
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

configs.julials = {
  default_config = {
    cmd = cmd,
    on_new_config = function(new_config, root_dir)
      new_config.cmd_cwd = root_dir
    end,
    filetypes = { 'julia' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/julia-vscode/julia-vscode/master/package.json',
    description = [[
https://github.com/julia-vscode/julia-vscode

`LanguageServer.jl` can be installed with `julia` and `Pkg`:
```sh
julia -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer")'
```
This installs LanguageServer.jl into your global julia environment.

In order to have LanguageServer.jl pick up installed packages or dependencies in a Julia project, you must first instantiate the project:
```sh
julia --project=/path/to/my/project -e 'using Pkg; Pkg.instantiate()'
```
    ]],
  },
}

--- vim:et ts=2 sw=2
