local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.julials = {
  default_config = {
    cmd = {
        "julia", "--project", "--startup-file=no", "--history-file=no", "-e", [[
        using LanguageServer;
        using Pkg;
        server = LanguageServer.LanguageServerInstance(stdin, stdout, false, dirname(Pkg.Types.Context().env.project_file));
        server.runlinter = true; run(server);
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
julia -e 'using Pkg; Pkg.add("LanguageServer")'
```
    ]];
  };
}

configs.julials.install = function()
  local script = [[
  julia -e 'using Pkg; Pkg.add("LanguageServer")'
  ]]

  util.sh(script, vim.loop.os_homedir())
end

configs.julials.install_info = function()
  local script = [[
  julia -e 'using LanguageServer'
  ]]

  local status = pcall(vim.fn.system, script)

  return {
    is_installed = status and vim.v.shell_error == 0;
  }
end

--- vim:et ts=2 sw=2
