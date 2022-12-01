local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'fstar.exe', '--lsp' },
    filetypes = { 'fstar' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/FStarLang/FStar

LSP support is included in FStar. Make sure `fstar.exe` is in your PATH.
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
