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
    cmd = { 'aiken', 'lsp' },
    filetypes = { 'aiken' },
    root_dir = function(fname)
      return util.root_pattern('aiken.toml', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/aiken-lang/aiken

A language server for Aiken Programming Language.
[Installation](https://aiken-lang.org/installation-instructions)

It can be i
]],
  },
}
