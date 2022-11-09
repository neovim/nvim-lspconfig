local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'opencl-language-server' },
    filetypes = { 'opencl' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/Galarius/opencl-language-server

Build instructions can be found [here](https://github.com/Galarius/opencl-language-server/blob/main/_dev/build.md).

Prebuilt binaries are available for Linux, macOS and Windows [here](https://github.com/Galarius/opencl-language-server/releases).
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
