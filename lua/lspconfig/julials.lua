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
    on_new_config = function(new_config, _)
      local server_path = vim.fn.system 'julia --startup-file=no -q -e \'print(Base.find_package("LanguageServer"))\''
      local new_cmd = vim.deepcopy(cmd)
      table.insert(new_cmd, 2, '--project=' .. server_path:sub(0, -19))
      new_config.cmd = new_cmd
    end,
    filetypes = { 'julia' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.fn.getcwd()
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
The default config lazily evaluates the location of the julia language server from the your global julia packages.
This adds a small overhead on first opening of a julia file. To avoid this overhead, replace server_path in on_new_config with
a hard-coded path to the server.

```lua
require'lspconfig'.julials.setup{
    on_new_config = function(new_config,new_root_dir)
      server_path = "/path/to/directory/containing/LanguageServer.jl/src"
      cmd = {
        "julia",
        "--project="..server_path,
        "--startup-file=no",
        "--history-file=no",
        "-e", [[
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
        \]\]
    };
      new_config.cmd = cmd
    end
}
```
You can find the path to the globally installed LanguageServer.jl package with the following command:

```bash
julia -e 'print(Base.find_package("LanguageServer"))'
```

Note: the directory passed to `--project=...` should terminate with src, not LanguageServer.jl.

    ]],
  },
}

--- vim:et ts=2 sw=2
