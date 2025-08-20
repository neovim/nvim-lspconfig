---@brief
---
--- Cobol language support

---@type vim.lsp.Config
return {
  cmd = { 'cobol-language-support' },
  filetypes = { 'cobol' },
  root_markers = { '.git' },
}
