---@brief
---
--- https://ziggy-lang.io/documentation/ziggy-lsp/
---
--- Language server for schema files of the Ziggy data serialization format
return {
  cmd = { 'ziggy', 'lsp', '--schema' },
  filetypes = { 'ziggy_schema' },
  root_markers = { '.git' },
}
