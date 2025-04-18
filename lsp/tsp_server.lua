---@brief
---
--- https://github.com/microsoft/typespec
---
--- The language server for TypeSpec, a language for defining cloud service APIs and shapes.
---
--- `tsp-server` can be installed together with the typespec compiler via `npm`:
--- ```sh
--- npm install -g @typespec/compiler
--- ```
return {
  cmd = { 'tsp-server', '--stdio' },
  filetypes = { 'typespec' },
  root_markers = { 'tspconfig.yaml', '.git' },
}
