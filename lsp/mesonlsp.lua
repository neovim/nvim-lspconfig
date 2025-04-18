---@brief
---
--- https://github.com/JCWasmx86/mesonlsp
---
--- An unofficial, unendorsed language server for meson written in C++
return {
  cmd = { 'mesonlsp', '--lsp' },
  filetypes = { 'meson' },
  root_markers = { 'meson.build', 'meson_options.txt', 'meson.options', '.git' },
}
