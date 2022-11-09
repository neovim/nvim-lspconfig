local util = require 'lspconfig.util'

local workspace_markers = { 'hardhat.config.*', '.git' }

return {
  default_config = {
    cmd = { 'solc', '--lsp' },
    filetypes = { 'solidity' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://docs.soliditylang.org/en/latest/installing-solidity.html

solc is the native language server for the Solidity language.
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
