local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.hls = {
  default_config = {
    cmd = {"haskell-language-server-wrapper", "--lsp"};
    filetypes = {"haskell", "lhaskell"};
    root_dir = util.root_pattern("stack.yaml", "package.yaml", ".git");
  };

  docs = {
    description = [[
https://github.com/haskell/haskell-language-server

Integration point for ghcide and haskell-ide-engine. One IDE to rule them all.
        ]];

    default_config = {
      root_dir = [[root_pattern("stack.yaml", "package.yaml", ".git")]];
    };
  };
};

-- vim:et ts=2 sw=2
