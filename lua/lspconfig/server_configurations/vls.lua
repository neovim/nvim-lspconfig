local util = require 'lspconfig.util'

local workspace_markers = { 'v.mod', '.git' }

return {
  default_config = {
    cmd = { 'vls' },
    filetypes = { 'vlang' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/vlang/vls

V language server.

`v-language-server` can be installed by following the instructions [here](https://github.com/vlang/vls#installation).
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
