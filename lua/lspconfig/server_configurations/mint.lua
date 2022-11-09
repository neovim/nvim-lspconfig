local util = require 'lspconfig.util'

local workspace_markers = { 'mint.json', '.git' }

return {
  default_config = {
    cmd = { 'mint', 'ls' },
    filetypes = { 'mint' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    workspace_markers = workspace_markers,
    description = [[
https://www.mint-lang.com

Install Mint using the [instructions](https://www.mint-lang.com/install).
The language server is included since version 0.12.0.
]],
  },
}
