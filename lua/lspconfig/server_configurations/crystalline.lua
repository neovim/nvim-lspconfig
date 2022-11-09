local util = require 'lspconfig.util'

local workspace_markers = { 'shard.yml', '.git' }

return {
  default_config = {
    cmd = { 'crystalline' },
    filetypes = { 'crystal' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/elbywan/crystalline

Crystal language server.
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
