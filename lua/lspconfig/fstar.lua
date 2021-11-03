local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.fstar = {
  default_config = {
    cmd = { 'fstar.exe', '--lsp' },
    filetypes = { 'fstar' },
    root_dir = util.root_pattern '.git',
  },
  docs = {
    description = [[
https://github.com/FStarLang/FStar

LSP support is included in FStar. Make sure `fstar.exe` is in your PATH.
]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
