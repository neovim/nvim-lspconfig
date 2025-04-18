---@brief
---
--- Reason language server
---
--- You can install reason language server from [reason-language-server](https://github.com/jaredly/reason-language-server) repository.
return {
  cmd = { 'reason-language-server' },
  filetypes = { 'reason' },
  root_markers = { 'bsconfig.json', '.git' },
}
