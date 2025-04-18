---@brief
---
--- https://crates.io/crates/rune-languageserver
---
--- A language server for the [Rune](https://rune-rs.github.io/) Language,
--- an embeddable dynamic programming language for Rust
return {
  cmd = { 'rune-languageserver' },
  filetypes = { 'rune' },
  root_markers = { '.git' },
}
