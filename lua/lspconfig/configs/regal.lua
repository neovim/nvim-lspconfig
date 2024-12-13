local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'regal', 'language-server' },
    filetypes = { 'rego' },
    root_dir = function(fname)
      return util.root_pattern '*.rego'(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/StyraInc/regal

A linter for Rego, with support for running as an LSP server.

`regal` can be installed by running:
```sh
go install github.com/StyraInc/regal@latest
```
    ]],
  },
}
