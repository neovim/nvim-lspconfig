local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.ghcide = {
  default_config = {
    cmd = { "ghcide", "--lsp" };
    filetypes = { "haskell", "lhaskell" };
    root_dir = util.root_pattern("stack.yaml", "hie-bios", "BUILD.bazel", "cabal.config", "package.yaml");
  };

  docs = {
    vscode = "DigitalAssetHoldingsLLC.ghcide";
    description = [[
https://github.com/digital-asset/ghcide

A library for building Haskell IDE tooling.
]];
    default_config = {
      root_dir = [[root_pattern("stack.yaml", "hie-bios", "BUILD.bazel", "cabal.config", "package.yaml")]];
    };
  };
};

-- vim:et ts=2 sw=2
