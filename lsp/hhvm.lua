---@brief
---
--- Language server for programs written in Hack
--- https://hhvm.com/
--- https://github.com/facebook/hhvm
--- See below for how to setup HHVM & typechecker:
--- https://docs.hhvm.com/hhvm/getting-started/getting-started
return {
  cmd = { 'hh_client', 'lsp' },
  filetypes = { 'php', 'hack' },
  root_markers = { '.hhconfig' },
}
