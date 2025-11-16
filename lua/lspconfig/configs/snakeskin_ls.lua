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
    cmd = { 'snakeskin-cli', 'lsp', '--stdio' },
    filetypes = { 'ss' },
    root_dir = util.root_pattern 'package.json',
  },
  docs = {
    description = [[
https://www.npmjs.com/package/@snakeskin/cli

`snakeskin cli` can be installed via `npm`:
```sh
npm install -g @snakeskin/cli
```
]],
  },
}
