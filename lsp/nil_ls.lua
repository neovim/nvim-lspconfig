---@brief
---
--- https://github.com/oxalica/nil
---
--- A new language server for Nix Expression Language.
---
--- If you are using Nix with Flakes support, run `nix profile install github:oxalica/nil` to install.
--- Check the repository README for more information.
---
--- _See an example config at https://github.com/oxalica/nil/blob/main/dev/nvim-lsp.nix._
return {
  cmd = { 'nil' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
}
