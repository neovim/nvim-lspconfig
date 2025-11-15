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
    cmd = { 'solc', '--lsp' },
    filetypes = { 'solidity' },
    root_dir = util.root_pattern('hardhat.config.*', '.git'),
  },
  docs = {
    description = [[
https://docs.soliditylang.org/en/latest/installing-solidity.html

solc is the native language server for the Solidity language.
]],
  },
}
