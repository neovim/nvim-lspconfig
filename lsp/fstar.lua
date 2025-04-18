---@brief
---
--- https://github.com/FStarLang/FStar
---
--- LSP support is included in FStar. Make sure `fstar.exe` is in your PATH.
return {
  cmd = { 'fstar.exe', '--lsp' },
  filetypes = { 'fstar' },
  root_markers = { '.git' },
}
