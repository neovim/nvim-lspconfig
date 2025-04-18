---@brief
---
--- https://github.com/JCWasmx86/Swift-MesonLSP
---
--- Meson language server written in Swift
return {
  cmd = { 'Swift-MesonLSP', '--lsp' },
  filetypes = { 'meson' },
  root_markers = { 'meson.build', 'meson_options.txt', 'meson.options', '.git' },
}
