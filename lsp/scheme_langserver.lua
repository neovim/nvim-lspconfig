---@brief
---
--- https://github.com/ufo5260987423/scheme-langserver
--- `scheme-langserver`, a language server protocol implementation for scheme.
--- And for nvim user, please add .sls to scheme file extension list.

---@type vim.lsp.Config
return {
  cmd = { 'scheme-langserver', '~/.scheme-langserver.log', 'enable', 'disable' },
  filetypes = { 'scheme' },
  root_markers = {
    'Akku.manifest',
    '.git',
  },
}
