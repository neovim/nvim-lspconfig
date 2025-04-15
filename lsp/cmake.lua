---@brief
---
-- https://github.com/regen100/cmake-language-server
--
-- CMake LSP Implementation
return {
  cmd = { 'cmake-language-server' },
  filetypes = { 'cmake' },
  root_markers = { 'CMakePresets.json', 'CTestConfig.cmake', 'build', 'cmake' },
  init_options = {
    buildDirectory = 'build',
  },
}
