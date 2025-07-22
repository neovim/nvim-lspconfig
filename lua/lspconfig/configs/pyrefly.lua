local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'pyrefly', 'lsp' },
    filetypes = { 'python' },
    root_dir = util.root_pattern 'pyrefly.toml',
  },
  docs = {
    description = [[
https://pyrefly.org/

`pyrefly` a faster Python type checker written in Rust

`pyrefly` is still in development, so please report any errors to
-- our issues page at https://github.com/facebook/pyrefly/issues.

]],
  },
}
