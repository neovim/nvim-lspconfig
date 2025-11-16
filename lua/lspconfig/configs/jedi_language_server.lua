-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  '.git',
}

return {
  default_config = {
    cmd = { 'jedi-language-server' },
    filetypes = { 'python' },
    root_dir = util.root_pattern(unpack(root_files)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/pappasam/jedi-language-server

`jedi-language-server`, a language server for Python, built on top of jedi
    ]],
  },
}
