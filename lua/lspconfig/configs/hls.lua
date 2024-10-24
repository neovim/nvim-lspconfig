local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'haskell-language-server-wrapper', '--lsp' },
    filetypes = { 'haskell', 'lhaskell' },
    root_dir = util.root_pattern('hie.yaml', 'stack.yaml', 'cabal.project', '*.cabal', 'package.yaml'),
    single_file_support = true,
    settings = {
      haskell = {
        formattingProvider = 'ormolu',
        cabalFormattingProvider = 'cabalfmt',
      },
    },
  },

  docs = {
    description = [[
https://github.com/haskell/haskell-language-server

Haskell Language Server

If you are using HLS 1.9.0.0, enable the language server to launch on Cabal files as well:

```lua
require('lspconfig')['hls'].setup{
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
}
```
    ]],
  },
}
