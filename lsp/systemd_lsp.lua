---@brief
---
--- A Language Server Protocol (LSP) implementation for systemd unit files,
--- providing editing support with syntax highlighting,
--- diagnostics, autocompletion, and documentation.
---
--- `systemd-language-server` can be installed via `pip`:
--- ```sh
--- pip install systemd-language-server
--- ```
---
--- Language Server for Systemd unit files

---@type vim.lsp.Config
return {
  cmd = { 'systemd-lsp' },
  filetypes = { 'systemd', 'service', 'mount', 'device', 'nspawn', 'target', 'timer' },
  root_marker = vim.fn.getcwd()
}
