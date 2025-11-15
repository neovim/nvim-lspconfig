-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'
local bin_name = 'ntt'

return {
  default_config = {
    cmd = { bin_name, 'langserver' },
    filetypes = { 'ttcn' },
    root_dir = util.root_pattern '.git',
  },
  docs = {
    description = [[
https://github.com/nokia/ntt
Installation instructions can be found [here](https://github.com/nokia/ntt#Install).
Can be configured by passing a "settings" object to `ntt.setup{}`:
```lua
require('lspconfig').ntt.setup{
    settings = {
      ntt = {
      }
    }
}
```
]],
  },
}
