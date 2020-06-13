local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

local environment_directory = util.path.join(util.base_install_dir, "LSPNeovim")

-- determine appropriate project argument
-- TODO not entirely sure when this is evaluated, so it may not be safe
local function envdirstring()
  dir = util.path.join(util.base_install_dir, "LSPNeovim")
  if util.path.is_dir(dir) then
    return "--project=" .. dir
  else
    return nil
  end
end

-- TODO project string
configs.julials = {
  default_config = {
    cmd = {
        "julia", envdirstring(), "--startup-file=no", "--history-file=no",
        "-e", "using LSPNeovim; LSPNeovim.run()"
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
    environment_directory .. [[")']]

  util.sh(script, vim.loop.os_homedir())
end

configs.julials.install_info = function()
  local script = [[julia --startup-file=no --project=]] .. (envdirstring() or "") .. [[ -e 'using LSPNeovim']]

  local status = pcall(vim.fn.system, script)

  return {
    is_installed = status and vim.v.shell_error == 0;
  }
end

--- vim:et ts=2 sw=2
