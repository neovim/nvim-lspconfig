--- @brief
---
--- https://github.com/grafana/jsonnet-language-server
---
--- A Language Server Protocol (LSP) server for Jsonnet.
---
--- The language server can be installed with `go`:
--- ```sh
--- go install github.com/grafana/jsonnet-language-server@latest
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'jsonnet-language-server' },
  filetypes = {
    'jsonnet',
    'libsonnet',
  },
  root_markers = { 'jsonnetfile.json', '.git' },
}
