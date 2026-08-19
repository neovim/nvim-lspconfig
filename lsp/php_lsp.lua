---@brief
---
--- https://github.com/jorgsowa/php-lsp
---
--- A high-performance PHP language server written in Rust.
---
--- Installation: `cargo install php-lsp`, or download a pre-built binary from
--- https://github.com/jorgsowa/php-lsp/releases

---@type vim.lsp.Config
return {
  cmd = { 'php-lsp' },
  filetypes = { 'php' },
  root_markers = { 'composer.json', '.git' },
  workspace_required = true,
}
