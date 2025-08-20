---@brief
---
--- https://github.com/rydesun/fennel-language-server
---
--- Fennel language server protocol (LSP) support.

---@type vim.lsp.Config
return {
  cmd = { 'fennel-language-server' },
  filetypes = { 'fennel' },
  root_markers = { '.git' },
  settings = {},
}
