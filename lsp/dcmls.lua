---@brief
---
--- https://dcm.dev/
---
--- Language server for DCM analyzer.
return {
  cmd = { 'dcm', 'start-server', '--client=neovim' },
  filetypes = { 'dart' },
  root_markers = { 'pubspec.yaml' },
}
