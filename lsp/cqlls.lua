---@brief
---
--- https://github.com/Akzestia/cqlls
---
--- Install via cargo:
--- ```sh
--- cargo install cqlls
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'cqlls' },
  filetypes = { 'cql', 'cqlang' },
  root_markers = { '.cqlls', '.git' },
  settings = {},
}
