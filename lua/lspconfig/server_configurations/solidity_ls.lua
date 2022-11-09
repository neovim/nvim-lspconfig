local util = require 'lspconfig.util'

local bin_name = 'solidity-language-server'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.cmd'
end

local workspace_markers = { '.git', 'package.json' }

return {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'solidity' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
npm install -g solidity-language-server

solidity-language-server is a language server for the solidity language ported from the vscode solidity extension
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
