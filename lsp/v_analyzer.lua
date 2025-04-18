---@brief
---
--- https://github.com/vlang/v-analyzer
---
--- V language server.
---
--- `v-analyzer` can be installed by following the instructions [here](https://github.com/vlang/v-analyzer#installation).
return {
  cmd = { 'v-analyzer' },
  filetypes = { 'v', 'vsh', 'vv' },
  root_markers = { 'v.mod', '.git' },
}
