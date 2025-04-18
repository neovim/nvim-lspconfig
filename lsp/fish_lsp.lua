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
  cmd_env = { fish_lsp_show_client_popups = false },
  filetypes = { 'fish' },
  root_markers = { '.git' },
}
