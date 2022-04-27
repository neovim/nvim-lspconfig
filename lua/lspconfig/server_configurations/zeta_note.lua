local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'zeta-note' },
    filetypes = { 'markdown' },
    root_dir = util.root_pattern '.zeta.toml',
  },
  docs = {
    description = [[
https://github.com/artempyanykh/zeta-note

Markdown LSP server for easy note-taking with cross-references and diagnostics.

Binaries can be downloaded from https://github.com/artempyanykh/zeta-note/releases
```
]],
    default_config = {
      root_dir = [[root_pattern(".zeta.toml")]],
    },
  },
}
