---@brief
---
--- https://github.com/ewhauser/shuck
---
--- `shuck` can be installed via `cargo`:
--- ```sh
--- cargo install shuck-cli
--- ```
---
--- A lightning fast shell linter with LSP support for bash, zsh, posix, and mksh dialects.

---@type vim.lsp.Config
return {
  cmd = { 'shuck', 'server' },
  filetypes = { 'bash', 'sh', 'zsh' },
  root_markers = { '.shuck.toml', '.git' },
}
