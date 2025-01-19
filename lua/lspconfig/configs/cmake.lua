return {
  default_config = {
    cmd = { 'cmake-language-server' },
    filetypes = { 'cmake' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find(
          { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' },
          { path = fname, upward = true }
        )[1]
      )
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
