local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'dhall-lsp-server' },
    filetypes = { 'dhall' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server

language server for dhall

`dhall-lsp-server` can be installed via cabal:
```sh
cabal install dhall-lsp-server
```
prebuilt binaries can be found [here](https://github.com/dhall-lang/dhall-haskell/releases).
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
