local util = require 'lspconfig.util'

local workspace_markers = { 'tablegen_compile_commands.yml', '.git' }

return {
  default_config = {
    cmd = { 'tblgen-lsp-server' },
    filetypes = { 'tablegen' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://mlir.llvm.org/docs/Tools/MLIRLSP/#tablegen-lsp-language-server--tblgen-lsp-server

The Language Server for the LLVM TableGen language

`tblgen-lsp-server` can be installed at the llvm-project repository (https://github.com/llvm/llvm-project)
]],
    workspace_markers = workspace_markers,
  },
}
