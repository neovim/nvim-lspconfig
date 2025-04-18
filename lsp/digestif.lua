---@brief
---
--- https://github.com/astoff/digestif
---
--- Digestif is a code analyzer, and a language server, for LaTeX, ConTeXt et caterva. It provides
---
--- context-sensitive completion, documentation, code navigation, and related functionality to any
---
--- text editor that speaks the LSP protocol.
return {
  cmd = { 'digestif' },
  filetypes = { 'tex', 'plaintex', 'context' },
  root_markers = { '.git' },
}
