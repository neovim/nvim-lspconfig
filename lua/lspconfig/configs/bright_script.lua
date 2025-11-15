-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig/util'

return {
  default_config = {
    cmd = { 'bsc', '--lsp', '--stdio' },
    filetypes = { 'brs' },
    single_file_support = true,
    root_dir = util.root_pattern('makefile', 'Makefile', '.git'),
  },
  docs = {
    description = [[
https://github.com/RokuCommunity/brighterscript

`brightscript` can be installed via `npm`:
```sh
npm install -g brighterscript
```
]],
  },
}
