-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'antlersls', '--stdio' },
    filetypes = { 'html', 'antlers' },
    root_dir = util.root_pattern 'composer.json',
  },
  docs = {
    description = [[
https://www.npmjs.com/package/antlers-language-server

`antlersls` can be installed via `npm`:
```sh
npm install -g antlers-language-server
```
]],
  },
}
