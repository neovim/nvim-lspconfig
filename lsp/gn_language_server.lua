---@brief
---
--- https://github.com/google/gn-language-server
---
--- A language server for GN, the build configuration language used in Chromium,
--- Fuchsia, and other projects.

---@type vim.lsp.Config
return {
  cmd = { 'gn-language-server', '--stdio' },
  filetypes = { 'gn' },
  root_markers = { '.gn', '.git' },
}
