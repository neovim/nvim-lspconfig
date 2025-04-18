---@brief
---
--- https://mlir.llvm.org/docs/Tools/MLIRLSP/#pdll-lsp-language-server--mlir-pdll-lsp-server
---
--- The Language Server for the LLVM PDLL language
---
--- `mlir-pdll-lsp-server` can be installed at the llvm-project repository (https://github.com/llvm/llvm-project)
return {
  cmd = { 'mlir-pdll-lsp-server' },
  filetypes = { 'pdll' },
  root_markers = { 'pdll_compile_commands.yml', '.git' },
}
