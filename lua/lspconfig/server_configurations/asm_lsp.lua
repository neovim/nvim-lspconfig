local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 'vmasm' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/bergercookie/asm-lsp

Language Server for GAS/GO Assembly

`asm-lsp` can be installed via cargo:
cargo install asm-lsp
]],
  },
}
