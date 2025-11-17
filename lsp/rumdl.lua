---@brief
---
--- https://github.com/rvben/rumdl
---
--- Markdown Linter and Formatter written in Rust.

---@type vim.lsp.Config
return {
  cmd = { 'rumdl', 'server' },
  filetypes = { 'markdown' },
  root_markers = { '.git' },
}
