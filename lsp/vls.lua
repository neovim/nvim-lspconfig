---@brief
---
--- https://github.com/vlang/vls
---
--- V language server.
---
--- `v-language-server` can be installed by following the instructions [here](https://github.com/vlang/vls#installation).
return {
  cmd = { 'v', 'ls' },
  filetypes = { 'v', 'vlang' },
  root_markers = { 'v.mod', '.git' },
}
