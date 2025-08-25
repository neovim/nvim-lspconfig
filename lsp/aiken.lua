---@brief
---
--- https://github.com/aiken-lang/aiken
---
--- A language server for Aiken Programming Language.
--- [Installation](https://aiken-lang.org/installation-instructions)
---
--- It can be i

---@type vim.lsp.Config
return {
  cmd = { 'aiken', 'lsp' },
  filetypes = { 'aiken' },
  root_markers = { 'aiken.toml', '.git' },
}
