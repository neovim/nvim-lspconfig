---@brief
---
--- https://github.com/regen100/cmake-language-server
---
--- CMake LSP Implementation

---@type vim.lsp.Config
return {
  cmd = { 'cmake-language-server' },
  filetypes = { 'cmake' },
  root_markers = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' },
  init_options = {
    buildDirectory = 'build',
  },
}
