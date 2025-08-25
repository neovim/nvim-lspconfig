---@brief
---
--- https://github.com/uiua-lang/uiua/
---
--- The builtin language server of the Uiua interpreter.
---
--- The Uiua interpreter can be installed with `cargo install uiua`

---@type vim.lsp.Config
return {
  cmd = { 'uiua', 'lsp' },
  filetypes = { 'uiua' },
  root_markers = { 'main.ua', '.fmt.ua', '.git' },
}
