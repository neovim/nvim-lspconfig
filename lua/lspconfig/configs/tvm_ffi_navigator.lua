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
    cmd = { 'python', '-m', 'ffi_navigator.langserver' },
    filetypes = { 'python', 'cpp' },
    root_dir = util.root_pattern('pyproject.toml', '.git'),
  },
  docs = {
    description = [[
https://github.com/tqchen/ffi-navigator

The Language Server for FFI calls in TVM to be able jump between python and C++

FFI navigator can be installed with `pip install ffi-navigator`, buf for more details, please see
https://github.com/tqchen/ffi-navigator?tab=readme-ov-file#installation
]],
  },
}
