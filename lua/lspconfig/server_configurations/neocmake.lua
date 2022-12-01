local util = require 'lspconfig.util'

local workspace_markers = { '.git', 'build', 'cmake' }
return {
  default_config = {
    cmd = { 'neocmakelsp', '--stdio' },
    filetypes = { 'cmake' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/Decodetalkers/neocmakelsp

CMake LSP Implementation
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
