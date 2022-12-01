local util = require 'lspconfig.util'

local workspace_markers = { 'package.er', '.git' }

return {
  default_config = {
    cmd = { 'els' },
    filetypes = { 'erg' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/erg-lang/erg-language-server

ELS (erg-language-server) is a language server for the Erg programming language.

`els` can be installed via `cargo`:
 ```sh
 cargo install els
 ```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
