---@brief
---
--- https://github.com/nwolverson/purescript-language-server
---
--- The `purescript-language-server` can be added to your project and `$PATH` via
---
--- * JavaScript package manager such as npm, pnpm, Yarn, et al.
--- * Nix under the `nodePackages` and `nodePackages_latest` package sets
return {
  cmd = { 'purescript-language-server', '--stdio' },
  filetypes = { 'purescript' },
  root_markers = { 'bower.json', 'flake.nix', 'psc-package.json', 'shell.nix', 'spago.dhall', 'spago.yaml' },
}
