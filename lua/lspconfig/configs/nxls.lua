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
    cmd = { 'nxls', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_dir = util.root_pattern('nx.json', '.git'),
  },
  docs = {
    description = [[
https://github.com/nrwl/nx-console/tree/master/apps/nxls

nxls, a language server for Nx Workspaces

`nxls` can be installed via `npm`:
```sh
npm i -g nxls
```
]],
  },
}
