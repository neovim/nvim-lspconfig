---@brief
---
--- https://github.com/dprint/dprint
---
--- Pluggable and configurable code formatting platform written in Rust.
return {
  cmd = { 'dprint', 'lsp' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
    'jsonc',
    'markdown',
    'python',
    'toml',
    'rust',
    'roslyn',
    'graphql',
  },
  root_markers = { 'dprint.json', '.dprint.json', 'dprint.jsonc', '.dprint.jsonc' },
  settings = {},
}
