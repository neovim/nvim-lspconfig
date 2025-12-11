---@brief
---
--- https://github.com/elixir-tools/next-ls
---
--- **Please see the following [detailed instructions](https://www.elixir-tools.dev/docs/next-ls/installation/) for possible installation methods.**

---@type vim.lsp.Config
return {
  cmd = { 'nextls', '--stdio' },
  filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
  root_markers = { 'mix.exs', '.git' },
}
