local util = require 'lspconfig.util'

local workspace_markers = { 'shard.yml', '.git' }

return {
  default_config = {
    cmd = { 'scry' },
    filetypes = { 'crystal' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/crystal-lang-tools/scry

Crystal language server.
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
