---@brief
---
--- https://github.com/lexical-lsp/lexical
---
--- Lexical is a next-generation language server for the Elixir programming language.
---
--- To install from source, follow the [Detailed Installation Instructions](https://github.com/lexical-lsp/lexical/blob/main/pages/installation.md).
--- Ensure to point `cmd` to the generated `_build/dev/package/lexical/start_lexical.sh` executable.

---@type vim.lsp.Config
return {
  cmd = { 'lexical' },
  filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
  root_markers = { 'mix.exs', '.git' },
}
