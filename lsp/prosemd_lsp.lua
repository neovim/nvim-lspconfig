---@brief
---
--- https://github.com/kitten/prosemd-lsp
---
--- An experimental LSP for Markdown.
---
--- Please see the manual installation instructions: https://github.com/kitten/prosemd-lsp#manual-installation
return {
  cmd = { 'prosemd-lsp', '--stdio' },
  filetypes = { 'markdown' },
  root_markers = { '.git' },
}
