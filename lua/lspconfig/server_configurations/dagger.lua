local util = require 'lspconfig.util'

local workspace_markers = { 'cue.mod', '.git' }

return {
  default_config = {
    cmd = { 'cuelsp' },
    filetypes = { 'cue' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/dagger/cuelsp

Dagger's lsp server for cuelang.
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
