---@brief
---
---https://mlir.llvm.org/docs/Tools/MLIRLSP/#tablegen-lsp-language-server--tblgen-lsp-server
--
-- The Language Server for the LLVM TableGen language
--
-- `tblgen-lsp-server` can be installed at the llvm-project repository (https://github.com/llvm/llvm-project)
return {
  cmd = { 'tblgen-lsp-server' },
  filetypes = { 'tablegen' },
  root_markers = { 'tablegen_compile_commands.yml', '.git' },
}
