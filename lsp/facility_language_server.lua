---@brief
---
--- https://github.com/FacilityApi/FacilityLanguageServer
---
--- Facility language server protocol (LSP) support.

---@type vim.lsp.Config
return {
  cmd = { 'facility-language-server' },
  filetypes = { 'fsd' },
  root_markers = { '.git' },
}
