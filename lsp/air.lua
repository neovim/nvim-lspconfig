---@brief
---
--- https://github.com/posit-dev/air
---
--- Air is an R formatter and language server, written in Rust.
---
--- Refer to the [documentation](https://posit-dev.github.io/air/editors.html) for more details.
return {
  cmd = { 'air', 'language-server' },
  filetypes = { 'r' },
  root_markers = { 'air.toml', '.air.toml', '.git' },
}
