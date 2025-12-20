---@brief
---
--- A Language Server Protocol (LSP) implementation for Systemd unit files,
--- providing editing support with syntax highlighting,
--- diagnostics, autocompletion, and documentation.
---
--- `systemd-lsp` can be installed via `cargo`:
--- ```sh
--- cargo install systemd-lsp
--- ```
---
--- Language Server for Systemd unit files

---@type vim.lsp.Config
return {
  cmd = { 'systemd-lsp' },
  filetypes = { 'systemd' },
  root_dir = vim.fn.getcwd()
}
