---@brief
---
--- https://github.com/buddy-compiler/buddy-mlir#buddy-lsp-server
--- The Language Server for the buddy-mlir, a drop-in replacement for mlir-lsp-server,
--- supporting new dialects defined in buddy-mlir.
--- `buddy-lsp-server` can be installed at the buddy-mlir repository (buddy-compiler/buddy-mlir)
return {
  cmd = { 'buddy-lsp-server' },
  filetypes = { 'mlir' },
  root_markers = { '.git' },
}
