---@brief
---
--- https://github.com/coder3101/protols
---
--- `protols` can be installed via `cargo`:
--- ```sh
--- cargo install protols
--- ```
---
--- A Language Server for proto3 files. It uses tree-sitter and runs in single file mode.

---@type vim.lsp.Config
return {
  cmd = { 'protols' },
  filetypes = { 'proto' },
  root_markers = { '.git' },
}
