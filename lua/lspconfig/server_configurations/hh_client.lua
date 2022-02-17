local util = require 'lspconfig/util'

return {
  default_config = {
    cmd = { 'hh_client', 'lsp' },
    filetypes = { 'php' },
    root_dir = util.root_pattern '.hhconfig',
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/slackhq/vscode-hack/master/package.json',
    description = [[
https://hhvm.com/
https://github.com/facebook/hhvm

See below for how to setup HHVM & typechecker:
https://docs.hhvm.com/hhvm/getting-started/getting-started
]],
    default_config = {
      root_dir = [[root_pattern(".hhconfig")]],
    },
  },
}
