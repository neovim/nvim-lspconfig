---@brief
---
--- https://github.com/kadena-io/pact-lsp
---
--- The Pact language server

---@type vim.lsp.Config
return {
  cmd = { 'pact-lsp' },
  filetypes = { 'pact' },
  root_markers = { '.git' },
}
