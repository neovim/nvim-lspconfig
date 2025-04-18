---@brief
---
--- https://github.com/kcl-lang/kcl.nvim
---
--- Language server for the KCL configuration and policy language.
---
return {
  cmd = { 'kcl-language-server' },
  filetypes = { 'kcl' },
  root_markers = { '.git' },
}
