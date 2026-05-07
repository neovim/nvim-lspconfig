---@brief
---
--- https://github.com/jolars/panache
---
--- A language server, formatter, and linter for Markdown, Quarto, and R Markdown,
--- built in Rust with a lossless CST parser and support for external formatters
--- and linters on code blocks.
---
--- Install via `cargo install panache`, from the [releases page](https://github.com/jolars/panache/releases),
--- or via your system package manager (`nixpkgs`, AUR, `pipx install panache-cli`,
--- `npm install -g @panache-cli/panache`).

---@type vim.lsp.Config
return {
  cmd = { 'panache', 'lsp' },
  filetypes = { 'markdown', 'quarto', 'rmd' },
  root_markers = { '.panache.toml', 'panache.toml', '_quarto.yml', '_bookdown.yml', '.git' },
}
