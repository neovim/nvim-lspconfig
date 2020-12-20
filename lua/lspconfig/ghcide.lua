local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local vim = vim
vim.api.nvim_command('echomsg "NOTICE: \\"ghcide\\" has been deprecated. Use \\"haskell-language-server\\" instead of \\"ghcide\\". For more information, see https://github.com/haskell/ghcide/pull/939 .')

configs.ghcide = {
  default_config = {
    cmd = { "ghcide", "--lsp" };
    filetypes = { "haskell", "lhaskell" };
    root_dir = util.root_pattern("stack.yaml", "hie-bios", "BUILD.bazel", "cabal.config", "package.yaml");
  };

  docs = {
    description = [[
https://github.com/digital-asset/ghcide

A library for building Haskell IDE tooling.
"ghcide" isn't for end users now. Use "haskell-language-server" instead of "ghcide".
]];
    default_config = {
      root_dir = [[root_pattern("stack.yaml", "hie-bios", "BUILD.bazel", "cabal.config", "package.yaml")]];
    };
  };
};
-- vim:et ts=2 sw=2
