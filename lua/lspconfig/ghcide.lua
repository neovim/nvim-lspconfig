local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.ghcide = {
  default_config = {
    cmd = { "ghcide", "--lsp" };
    filetypes = { "haskell", "lhaskell" };
    root_dir = util.root_pattern("stack.yaml", "hie-bios", "BUILD.bazel", "cabal.config", "package.yaml");
  };

  docs = {
    package_json = "https://raw.githubusercontent.com/digital-asset/ghcide/master/extension/package.json";
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
