local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'cmake-language-server' },
    filetypes = { 'cmake' },
    root_dir = function(fname)
      return util.root_pattern('CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake')(fname)
    end,
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
  },
}
