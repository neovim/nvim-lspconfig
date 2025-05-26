---@brief
---
--- https://github.com/ndonfris/fish-lsp
---
--- A Language Server Protocol (LSP) tailored for the fish shell.
--- This project aims to enhance the coding experience for fish,
--- by introducing a suite of intelligent features like auto-completion,
--- scope aware symbol analysis, per-token hover generation, and many others.
---
--- [homepage](https://www.fish-lsp.dev/)
return {
  cmd = { 'fish-lsp', 'start' },
  filetypes = { 'fish' },
  root_markers = { 'config.fish', '.git' },
}
