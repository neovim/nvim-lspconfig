---@brief
---
--- https://github.com/errata-ai/vale-ls
---
--- An implementation of the Language Server Protocol (LSP) for the Vale command-line tool.

---@type vim.lsp.Config
return {
  cmd = { 'vale-ls' },
  filetypes = { 'asciidoc', 'markdown', 'text', 'tex', 'rst', 'html', 'xml' },
  root_markers = { '.vale.ini' },
}
