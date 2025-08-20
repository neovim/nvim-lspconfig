---@brief
---
--- https://github.com/roc-lang/roc/tree/main/crates/language_server#roc_language_server
---
--- The built-in language server for the Roc programming language.
--- [Installation](https://github.com/roc-lang/roc/tree/main/crates/language_server#installing)

---@type vim.lsp.Config
return {
  cmd = { 'roc_language_server' },
  filetypes = { 'roc' },
  root_markers = { '.git' },
}
