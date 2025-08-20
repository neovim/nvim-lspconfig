---@brief
---
--- https://github.com/kitagry/bqls
---
--- The `bqls` BigQuery language server can be installed by running:
---
--- ```sh
--- $ go install github.com/kitagry/bqls@latest
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'bqls' },
  filetypes = { 'sql' },
  root_markers = { '.git' },
  settings = {},
}
