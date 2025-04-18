---@brief
---
--- https://github.com/godofavacyn/gdshader-lsp
---
--- A language server for the Godot Shading language.
return {
  cmd = { 'gdshader-lsp', '--stdio' },
  filetypes = { 'gdshader', 'gdshaderinc' },
  root_markers = { 'project.godot' },
}
