local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.leanls = {
  default_config = {
    cmd = {"lean-language-server", "--stdio"};
    filetypes = {"lean"};
    root_dir = util.root_pattern(".git");
  };
  docs = {
    vscode = "jroesch.lean";
    description = [[
https://github.com/leanprover/lean-client-js/tree/master/lean-language-server

Lean language server.
    ]];
    default_config = {
      root_dir = [[util.root_pattern(".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
