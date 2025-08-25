---@brief
---
--- https://github.com/Retsediv/hydra-lsp
---
--- LSP for Hydra Python package config files.

---@type vim.lsp.Config
return {
  cmd = { 'hydra-lsp' },
  filetypes = { 'yaml' },
  root_markers = { '.git' },
}
