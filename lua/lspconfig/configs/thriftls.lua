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
    cmd = { 'thriftls' },
    filetypes = { 'thrift' },
    root_dir = util.root_pattern '.thrift',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/joyme123/thrift-ls

you can install thriftls by mason or download binary here: https://github.com/joyme123/thrift-ls/releases
]],
  },
}
