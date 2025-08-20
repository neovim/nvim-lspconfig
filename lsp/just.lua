---@brief
---
--- https://github.com/terror/just-lsp
---
--- `just-lsp` is an LSP for just built on top of the tree-sitter-just parser.

---@type vim.lsp.Config
return {
  cmd = { 'just-lsp' },
  filetypes = { 'just' },
  root_markers = { '.git' },
}
