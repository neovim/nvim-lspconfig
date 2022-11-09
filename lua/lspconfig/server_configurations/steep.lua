local util = require 'lspconfig.util'

local workspace_markers = { 'Steepfile', '.git' }

return {
  default_config = {
    cmd = { 'steep', 'langserver' },
    filetypes = { 'ruby', 'eruby' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/soutaro/steep

`steep` is a static type checker for Ruby.

You need `Steepfile` to make it work. Generate it with `steep init`.
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
