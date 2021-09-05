local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.solang = {
  default_config = {
    cmd = { 'solang', '--language-server' },
    filetypes = { 'solidity' },
    root_dir = util.root_pattern '.git',
  },
  docs = {
    description = [[
Solang provides the following:

See [docs](https://solang.readthedocs.io/en/latest/installing.html) for installation.

A language server for Solidity providing, diagnostics and hover docs

There is currently no support for completion, or goto definition, references etc..
]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
