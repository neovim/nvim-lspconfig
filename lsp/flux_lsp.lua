---@brief
---
--- https://github.com/influxdata/flux-lsp
--- `flux-lsp` can be installed via `cargo`:
--- ```sh
--- cargo install --git https://github.com/influxdata/flux-lsp
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'flux-lsp' },
  filetypes = { 'flux' },
  root_markers = { '.git' },
}
