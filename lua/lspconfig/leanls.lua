local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.leanls = {
  default_config = {
    cmd = {"lean-language-server", "--stdio"};
    filetypes = {"lean"};
    root_dir = util.root_pattern(".git");
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/leanprover/vscode-lean/master/package.json";
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
