---@brief
---
--- https://github.com/JCWasmx86/Swift-MesonLSP
---
--- Meson language server written in Swift

---@type vim.lsp.Config
return {
  cmd = { 'Swift-MesonLSP', '--lsp' },
  filetypes = { 'meson' },
  root_markers = { 'meson.build', 'meson_options.txt', 'meson.options', '.git' },
}
