local util = require 'lspconfig.util'

local workspace_markers = { 'flake.nix', '.git' }

return {
  default_config = {
    cmd = { 'nil' },
    filetypes = { 'nix' },
    workspace_markers = workspace_markers,
    single_file_support = true,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/oxalica/nil

A new language server for Nix Expression Language.

If you are using Nix with Flakes support, run `nix profile install github:oxalica/nil` to install.
Check the repository README for more information.
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
