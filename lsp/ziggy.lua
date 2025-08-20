---@brief
---
--- https://ziggy-lang.io/documentation/ziggy-lsp/
---
--- Language server for the Ziggy data serialization format

---@type vim.lsp.Config
return {
  cmd = { 'ziggy', 'lsp' },
  filetypes = { 'ziggy' },
  root_markers = { '.git' },
}
