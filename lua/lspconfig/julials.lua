local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local environment_directory = util.path.join(util.base_install_dir, "julials")

configs.julials = {
  default_config = {
    cmd = {
        "julia", "--project=" .. environment_directory, "--startup-file=no", "--history-file=no", "-e", [[
        using Pkg;
        Pkg.instantiate()
        using LanguageServer; using SymbolServer;
        depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
        project_path = dirname(something(Base.current_project(pwd()), Base.load_path_expand(LOAD_PATH[2])))
        # Make sure that we only load packages from this environment specifically.
        empty!(LOAD_PATH)
        push!(LOAD_PATH, "@")
        @info "Running language server" env=Base.load_path()[1] pwd() project_path depot_path
        server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path);
        server.runlinter = true;
        run(server);
        ]]
    };
    filetypes = {'julia'};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/julia-vscode/julia-vscode/master/package.json";
    description = [[
https://github.com/julia-vscode/julia-vscode
`LanguageServer.jl` can be installed via `:LspInstall julials` or by yourself the `julia` and `Pkg`:
```sh
julia --project=]] .. environment_directory .. [[ -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer")'
```
If you want to install the LanguageServer manually, you will have to ensure that the Julia environment is stored in this location:
```vim
:lua print(require'lspconfig'.util.path.join(require'lspconfig'.util.base_install_dir, "julials"))
```
    ]];
  };
}

configs.julials.install = function()

  local script = [[
  julia --project=]] .. environment_directory .. [[ -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer")'
  ]]

  util.sh(script, vim.loop.os_homedir())
end

configs.julials.install_info = function()
  local script = [[
  julia --project=]] .. environment_directory .. [[ -e 'using LanguageServer; using SymbolServer'
  ]]

  local status = pcall(vim.fn.system, script)

  return {
    is_installed = status and vim.v.shell_error == 0;
  }
end

--- vim:et ts=2 sw=2
