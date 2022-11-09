local util = require 'lspconfig.util'

local workspace_markers = { 'stack.yaml', 'hie-bios', 'BUILD.bazel', 'cabal.config', 'package.yaml' }

return {
  default_config = {
    cmd = { 'ghcide', '--lsp' },
    filetypes = { 'haskell', 'lhaskell' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },

  docs = {
    description = [[
https://github.com/digital-asset/ghcide

A library for building Haskell IDE tooling.
"ghcide" isn't for end users now. Use "haskell-language-server" instead of "ghcide".
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
