---@brief
---
--- https://github.com/dcermak/rpm-spec-language-server
---
--- Language server protocol (LSP) support for RPM Spec files.
return {
  cmd = { 'python3', '-mrpm_lsp_server', '--stdio' },
  filetypes = { 'spec' },
  root_markers = { '.git' },
  settings = {},
}
