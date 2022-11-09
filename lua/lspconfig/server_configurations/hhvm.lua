local util = require 'lspconfig.util'

local workspace_markers = { '.hhconfig' }

return {
  default_config = {
    cmd = { 'hh_client', 'lsp' },
    filetypes = { 'php', 'hack' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
Language server for programs written in Hack
https://hhvm.com/
https://github.com/facebook/hhvm
See below for how to setup HHVM & typechecker:
https://docs.hhvm.com/hhvm/getting-started/getting-started
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
