---@brief
---
--- https://github.com/mistweaverco/kulala-ls
---
--- A minimal language server for HTTP syntax.

---@type vim.lsp.Config
return {
  cmd = { 'kulala-ls', '--stdio' },
  filetypes = { 'http' },
  root_markers = { '.git' },
}
