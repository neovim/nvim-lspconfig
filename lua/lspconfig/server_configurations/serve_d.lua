local util = require 'lspconfig.util'

local workspace_markers = { 'dub.json', 'dub.sdl', '.git' }

return {
  default_config = {
    cmd = { 'serve-d' },
    filetypes = { 'd' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
           https://github.com/Pure-D/serve-d

           `Microsoft language server protocol implementation for D using workspace-d.`
           Download a binary from https://github.com/Pure-D/serve-d/releases and put it in your $PATH.
        ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
