---@brief
---
--- https://ziggy-lang.io/documentation/ziggy-lsp/
---
--- Language server for schema files of the Ziggy data serialization format

---@type vim.lsp.Config
return {
  cmd = { 'ziggy', 'lsp', '--schema' },
  filetypes = { 'ziggy_schema' },
  root_markers = { '.git' },
}
