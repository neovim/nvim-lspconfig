---@brief
---
--- https://pgtools.dev
---
--- A collection of language tools and a Language Server Protocol (LSP) implementation for Postgres, focusing on developer experience and reliable SQL tooling.
return {
  cmd = { 'postgrestools', 'lsp-proxy' },
  filetypes = {
    'sql',
  },
  root_markers = { 'postgrestools.jsonc' },
}
