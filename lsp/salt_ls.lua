---@brief
---
--- Language server for Salt configuration files.
--- https://github.com/dcermak/salt-lsp
---
--- The language server can be installed with `pip`:
--- ```sh
--- pip install salt-lsp
--- ```
return {
  cmd = { 'salt_lsp_server' },
  filetypes = { 'sls' },
  root_markers = { '.git' },
}
