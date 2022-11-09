local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'tilt', 'lsp', 'start' },
    filetypes = { 'tiltfile' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/tilt-dev/tilt

Tilt language server.

You might need to add filetype detection manually:

```vim
autocmd BufRead Tiltfile setf=tiltfile
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
