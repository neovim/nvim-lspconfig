local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    filetypes = { 'bsl', 'os' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
    https://github.com/1c-syntax/bsl-language-server

    Language Server Protocol implementation for 1C (BSL) - 1C:Enterprise 8 and OneScript languages.

    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
