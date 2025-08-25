---@brief
---
--- https://github.com/FStarLang/FStar
---
--- LSP support is included in FStar. Make sure `fstar.exe` is in your PATH.

---@type vim.lsp.Config
return {
  cmd = { 'fstar.exe', '--lsp' },
  filetypes = { 'fstar' },
  root_markers = { '.git' },
}
