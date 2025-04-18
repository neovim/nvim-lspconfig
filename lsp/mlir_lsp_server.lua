---@brief
---
--- https://mlir.llvm.org/docs/Tools/MLIRLSP/#mlir-lsp-language-server--mlir-lsp-server=
---
--- The Language Server for the LLVM MLIR language
---
--- `mlir-lsp-server` can be installed at the llvm-project repository (https://github.com/llvm/llvm-project)
return {
  cmd = { 'mlir-lsp-server' },
  filetypes = { 'mlir' },
  root_markers = { '.git' },
}
