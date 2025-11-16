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
    cmd = { 'bal', 'start-language-server' },
    filetypes = { 'ballerina' },
    root_dir = util.root_pattern 'Ballerina.toml',
  },
  docs = {
    description = [[
Ballerina language server

The Ballerina language's CLI tool comes with its own language server implementation.
The `bal` command line tool must be installed and available in your system's PATH.
]],
  },
}
