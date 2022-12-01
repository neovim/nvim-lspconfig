local util = require 'lspconfig.util'

local workspace_markers = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' }

return {
  default_config = {
    cmd = { 'cmake-language-server' },
    filetypes = { 'cmake' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
    init_options = {
      buildDirectory = 'build',
    },
  },
  docs = {
    description = [[
https://github.com/regen100/cmake-language-server

CMake LSP Implementation
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
