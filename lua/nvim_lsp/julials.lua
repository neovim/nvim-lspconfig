local util = require 'nvim_lsp/util'
local lsp = vim.lsp

require'nvim_lsp/skeleton'.julials = {
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
    log_level = vim.lsp.protocol.MessageType.Warning;
    settings = {};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
  };
}

require'nvim_lsp/skeleton'.julials.install = function()
  local script = [[
  julia -e 'using Pkg; Pkg.add("LanguageServer")'
  ]]

  nvim_lsp.util.sh(script, vim.loop.os_homedir())
end

require'nvim_lsp/skeleton'.julials.install_info = function()
  local script = [[
  julia -e 'using LanguageServer'
  ]]

  local status = pcall(vim.fn.system, script)

  return {
    is_installed = status and vim.v.shell_error == 0;
  }
end

--- vim:et ts=2 sw=2
