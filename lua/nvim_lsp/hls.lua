local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.hls = {
  default_config = {
    cmd = {"haskell-language-server-wrapper", "--lsp"};
    filetypes = {"haskell", "lhaskell"};
    root_dir = util.root_pattern("stack.yaml", "package.yaml", ".git");
  };

  docs = {
    package_json = "https://raw.githubusercontent.com/haskell/vscode-haskell/master/package.json";
    description = [[
https://github.com/haskell/haskell-language-server
        ]];

    default_config = {
      root_dir = [[root_pattern("stack.yaml", "package.yaml", ".git")]];
    };
  };
};

-- vim:et ts=2 sw=2
