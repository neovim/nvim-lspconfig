local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'superhtml', 'lsp' },
    filetypes = { 'superhtml', 'html' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/kristoff-it/superhtml

HTML Language Server & Templating Language Library

This LSP is designed to tightly adhere to the HTML spec as well as enforcing
some additional rules that ensure HTML clarity.

If you want to disable HTML support for another HTML LSP, add the following
to your configuration:

```lua
require'lspconfig'.superhtml.setup {
  filetypes = { 'superhtml' }
}
```
        ]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
