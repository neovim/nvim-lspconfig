local util = require 'lspconfig.util'

local workspace_markers = { 'bsconfig.json', '.git' }

return {
  default_config = {
    cmd = { 'reason-language-server' },
    filetypes = { 'reason' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
Reason language server

You can install reason language server from [reason-language-server](https://github.com/jaredly/reason-language-server) repository.
]],
  },
}
