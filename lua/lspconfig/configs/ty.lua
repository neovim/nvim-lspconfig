local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_dir = function(fname)
      return util.root_pattern('pyproject.toml', 'ty.toml')(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/astral-sh/ty

An extremely fast Python type checker and language server, written in Rust.

Server settings can be provided via:

```lua
require('lspconfig').ty.setup {}
```

  ]],
  },
}
