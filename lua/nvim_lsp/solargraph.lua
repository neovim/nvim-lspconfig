local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

skeleton.solargraph = {
  default_config = {
    cmd = {"solargraph", "stdio"};
    filetypes = {"ruby"};
    root_dir = util.root_pattern("Gemfile", ".git");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  docs = {
    vscode = "castwide.solargraph";
    package_json = "https://raw.githubusercontent.com/castwide/vscode-solargraph/master/package.json";
    description = [[
https://solargraph.org/

solargraph, a language server for Ruby

You can install solargraph via gem install.

```sh
gem install solargraph
```
    ]];
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]];
    };
  };
};
-- vim:et ts=2 sw=2
