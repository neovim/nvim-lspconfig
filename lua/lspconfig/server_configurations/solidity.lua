local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'solidity-ls', '--stdio' },
    filetypes = { 'solidity' },
    root_dir = util.root_pattern('.git', 'package.json'),
  },
  docs = {
    description = [[
npm i solidity-ls -g

Make sure that solc is installed and it's the same version of the file.  solc-select is recommended.

Solidity language server is a LSP with autocomplete, go to definition and diagnostics.

If you use brownie, use this root_dir:
root_dir = util.root_pattern('brownie-config.yaml', '.git')

]],
    default_config = {
      root_dir = [[root_pattern("package.json", ".git")]],
    },
  },
}
