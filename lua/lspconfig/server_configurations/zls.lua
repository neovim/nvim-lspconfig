local util = require 'lspconfig.util'

local workspace_markers = { 'zls.json', '.git' }

return {
  default_config = {
    cmd = { 'zls' },
    filetypes = { 'zig', 'zir' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/zigtools/zls

Zig LSP implementation + Zig Language Server
        ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
