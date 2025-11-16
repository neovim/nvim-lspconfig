-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'purescript-language-server', '--stdio' },
    filetypes = { 'purescript' },
    root_dir = util.root_pattern(
      'bower.json',
      'flake.nix',
      'psc-package.json',
      'shell.nix',
      'spago.dhall',
      'spago.yaml'
    ),
  },
  docs = {
    description = [[
https://github.com/nwolverson/purescript-language-server

The `purescript-language-server` can be added to your project and `$PATH` via

* JavaScript package manager such as npm, pnpm, Yarn, et al.
* Nix under the `nodePackages` and `nodePackages_latest` package sets
]],
  },
}
