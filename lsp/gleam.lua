---@brief
---
--- https://github.com/gleam-lang/gleam
---
--- A language server for Gleam Programming Language.
---
--- It comes with the Gleam compiler, for installation see: [Installing Gleam](https://gleam.run/getting-started/installing/)
return {
  cmd = { 'gleam', 'lsp' },
  filetypes = { 'gleam' },
  root_markers = { 'gleam.toml', '.git' },
}
