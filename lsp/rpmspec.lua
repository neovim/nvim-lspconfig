---@brief
---
--- https://github.com/dcermak/rpm-spec-language-server
---
--- Language server protocol (LSP) support for RPM Spec files.
---
--- `rpm-spec-language-server` can be installed by running,
---
--- ```sh
--- pip install rpm-spec-language-server
--- ```
return {
  cmd = { 'rpm_lsp_server', '--stdio' },
  filetypes = { 'spec' },
  root_markers = { '.git' },
  settings = {},
}
