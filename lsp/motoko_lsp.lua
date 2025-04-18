---@brief
---
--- https://github.com/dfinity/vscode-motoko
---
--- Language server for the Motoko programming language.
return {
  cmd = { 'motoko-lsp', '--stdio' },
  filetypes = { 'motoko' },
  root_markers = { 'dfx.json', '.git' },
  init_options = {
    formatter = 'auto',
  },
}
