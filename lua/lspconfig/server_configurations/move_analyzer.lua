local util = require 'lspconfig.util'

local workspace_markers = { 'Move.toml' }

return {
  default_config = {
    cmd = { 'move-analyzer' },
    filetypes = { 'move' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  commands = {},
  docs = {
    description = [[
https://github.com/move-language/move/tree/main/language/move-analyzer

Language server for Move

The `move-analyzer` can be installed by running:

```
cargo install --git https://github.com/move-language/move move-analyzer
```

See [`move-analyzer`'s doc](https://github.com/move-language/move/blob/1b258a06e3c7d2bc9174578aac92cca3ac19de71/language/move-analyzer/editors/code/README.md#how-to-install) for details.
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
