local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'mint', 'ls' },
    filetypes = { 'mint' },
    root_dir = function(fname)
      return util.root_pattern 'mint.json'(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://www.mint-lang.com

Install Mint using the [instructions](https://www.mint-lang.com/install).
The language server is included since version 0.12.0.
]],
  },
}
