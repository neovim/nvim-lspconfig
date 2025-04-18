---@brief
---
--- https://github.com/Leathong/openscad-LSP
---
--- A Language Server Protocol server for OpenSCAD
---
--- You can build and install `openscad-lsp` binary with `cargo`:
--- ```sh
--- cargo install openscad-lsp
--- ```
return {
  cmd = { 'openscad-lsp', '--stdio' },
  filetypes = { 'openscad' },
  root_markers = { '.git' },
}
