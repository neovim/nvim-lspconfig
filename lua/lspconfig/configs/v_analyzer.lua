local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'v-analyzer' },
    filetypes = { 'v', 'vsh', 'vv' },
    root_dir = util.root_pattern('v.mod', '.git'),
  },
  docs = {
    description = [[
https://github.com/vlang/v-analyzer

V language server.

`v-analyzer` can be installed by following the instructions [here](https://github.com/vlang/v-analyzer#installation).
]],
  },
}
