---@brief
---
--- https://github.com/pest-parser/pest-ide-tools
---
--- Language server for pest grammars.

---@type vim.lsp.Config
return {
  cmd = { 'pest-language-server' },
  filetypes = { 'pest' },
  root_markers = { '.git' },
}
