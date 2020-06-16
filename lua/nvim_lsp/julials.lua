local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

local envdir = util.path.join(util.base_install_dir, "LSPNeovim")

local runscript = util.path.join(envdir, "bin", "run.jl")

configs.julials = {
  default_config = {
    cmd = {
        "julia", "--project=" .. envdir, "--startup-file=no", "--history-file=no",
        runscript
    };
    filetypes = {'julia'};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/julia-vscode/julia-vscode/master/package.json";
    description = [[
LSPNeovim.jl can be installed via `:LspInstall julials` or you can add it in the usual way to your default
environment by doing `Pkg.add("LSPNeovim")`.
    ]];
  };
}

configs.julials.install = function()

  local script = [[julia --startup-file=no -e 'using LibGit2; LibGit2.clone("https://github.com/ExpandingMan/LSPNeovim.jl", "]] ..
    envdir .. [[")']]

  util.sh(script, vim.loop.os_homedir())
end

configs.julials.install_info = function()
  return {is_installed=util.path.is_file(util.path.join(envdir,"Project.toml"))}
end

--- vim:et ts=2 sw=2
