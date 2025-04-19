---@brief
---
--- https://github.com/errata-ai/vale-ls
---
--- An implementation of the Language Server Protocol (LSP) for the Vale command-line tool.
return {
  cmd = { 'vale-ls' },
  filetypes = { 'markdown', 'text', 'tex', 'rst' },
  root_markers = { '.vale.ini' },
}
