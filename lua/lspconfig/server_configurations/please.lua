local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'bzl' },
    root_dir = function(fname)
      return util.root_pattern '.plzconfig'(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
`plz` will automatically install the LSP for you on first run
]],
  },
}
