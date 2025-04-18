---@brief
---
--- https://github.com/nerdypepper/statix
---
--- lints and suggestions for the nix programming language
return {
  cmd = { 'statix', 'check', '--stdin' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
}
