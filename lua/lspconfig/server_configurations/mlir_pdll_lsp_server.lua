local util = require 'lspconfig.util'

local workspace_markers = { 'pdll_compile_commands.yml', '.git' }

return {
  default_config = {
    cmd = { 'mlir-pdll-lsp-server' },
    filetypes = { 'pdll' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://mlir.llvm.org/docs/Tools/MLIRLSP/#pdll-lsp-language-server--mlir-pdll-lsp-server

The Language Server for the LLVM PDLL language

`mlir-pdll-lsp-server` can be installed at the llvm-project repository (https://github.com/llvm/llvm-project)
]],
    workspace_markers = workspace_markers,
  },
}
