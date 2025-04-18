---@brief
---
--- https://github.com/lexical-lsp/lexical
---
--- Lexical is a next-generation language server for the Elixir programming language.
---
--- Follow the [Detailed Installation Instructions](https://github.com/lexical-lsp/lexical/blob/main/pages/installation.md)
---
--- **By default, `lexical` doesn't have a `cmd` set.**
--- This is because nvim-lspconfig does not make assumptions about your path.
return {
  filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
  root_markers = { 'mix.exs', '.git' },
}
