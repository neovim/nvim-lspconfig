local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'luau-lsp', 'lsp' },
    filetypes = { 'luau' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    [[
https://github.com/JohnnyMorganz/luau-lsp

Language server for the [Luau](https://luau-lang.org/) language.

`luau-lsp` can be installed by downloading one of the release assets available at https://github.com/JohnnyMorganz/luau-lsp.

You might also have to set up automatic filetype detection for Luau files, for example like so:

```vim
autocmd BufRead,BufNewFile *.luau setf luau
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
