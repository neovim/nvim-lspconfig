-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

local root_files = { 'configure.ac', 'Makefile', 'Makefile.am', '*.mk' }

return {
  default_config = {
    cmd = { 'autotools-language-server' },
    filetypes = { 'config', 'automake', 'make' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/Freed-Wu/autotools-language-server

`autotools-language-server` can be installed via `pip`:
```sh
pip install autotools-language-server
```

Language server for autoconf, automake and make using tree sitter in python.
]],
  },
}
