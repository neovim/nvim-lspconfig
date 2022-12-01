local util = require 'lspconfig.util'

local workspace_markers = { 'go.work', 'go.mod', '.git' }

return {
  default_config = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
