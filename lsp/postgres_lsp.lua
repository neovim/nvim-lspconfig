---@brief
---
--- https://pg-language-server.com
---
--- A collection of language tools and a Language Server Protocol (LSP) implementation for Postgres, focusing on developer experience and reliable SQL tooling.

---@type vim.lsp.Config
return {
  cmd = { 'postgres-language-server', 'lsp-proxy' },
  filetypes = {
    'sql',
  },
  root_markers = { 'postgres-language-server.jsonc' },
}
