local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'nimlangserver' },
    filetypes = { 'nim' },
    root_dir = function(fname)
      return util.root_pattern '*.nimble'(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/nim-lang/langserver


`nim-langserver` can be installed via the `nimble` package manager:
```sh
nimble install nimlangserver
```
    ]],
  },
}
