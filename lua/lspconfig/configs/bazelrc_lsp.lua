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
    cmd = { 'bazelrc-lsp', 'lsp' },
    filetypes = { 'bazelrc' },
    root_dir = util.root_pattern('WORKSPACE', 'WORKSPACE.bazel', 'MODULE.bazel'),
  },
  docs = {
    description = [[
https://github.com/salesforce-misc/bazelrc-lsp

`bazelrc-lsp` is a LSP for `.bazelrc` configuration files.

The `.bazelrc` file type is not detected automatically, you can register it manually (see below) or override the filetypes:

```lua
vim.filetype.add {
  pattern = {
    ['.*.bazelrc'] = 'bazelrc',
  },
}
```
]],
  },
}
