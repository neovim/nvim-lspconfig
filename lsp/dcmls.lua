---@brief
---
--- https://dcm.dev/
---
--- Language server for DCM analyzer.

---@type vim.lsp.Config
return {
  cmd = { 'dcm', 'start-server', '--client=neovim' },
  filetypes = { 'dart' },
  root_markers = { 'pubspec.yaml' },
}
