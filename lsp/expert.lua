---@brief
---
--- https://github.com/elixir-lang/expert
---
--- Expert is the official language server implementation for the Elixir programming language.

---@type vim.lsp.Config
return {
  filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
  root_markers = { '.git', 'mix.exs' },
  cmd = { 'expert' },
}
