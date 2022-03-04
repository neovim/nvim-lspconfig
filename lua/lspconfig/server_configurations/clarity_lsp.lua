local util = require 'lspconfig.util'

local bin_name = 'clarity-lsp'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.cmd'
end

return {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'clar', 'clarity' },
    root_dir = util.root_pattern('.git'),
  },
  docs = {
    description = [[
https://github.com/hirosystems/clarity-lsp

`clarity-lsp` provides some great insights about your code, without publishing your smart contracts to a blockchain.

`clarity-lsp` is a language server for the Clarity. Clarity is a decidable smart contract language that optimizes for predictability and security. Smart contracts allow developers to encode essential business logic on a blockchain.

```lua
require('lspconfig').clarity_lsp.setup({})
```
]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
