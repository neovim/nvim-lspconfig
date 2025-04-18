---@brief
---
--- https://github.com/influxdata/flux-lsp
--- `flux-lsp` can be installed via `cargo`:
--- ```sh
--- cargo install --git https://github.com/influxdata/flux-lsp
--- ```
return {
  cmd = { 'flux-lsp' },
  filetypes = { 'flux' },
  root_markers = { '.git' },
}
