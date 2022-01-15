local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {},
    filetypes = { 'reason' },
    root_dir = util.root_pattern('bsconfig.json', '.git'),
    settings = {},
  },
  docs = {
    description = [[
Reason language server

**By default, reasonls doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path.
You have to install the language server manually.

You can instsall reason language server from [reason-language-server](https://github.com/jaredly/reason-language-server) repository.

Clone the vim-reason repo and point `cmd` to `server.js` inside `server/out` directory:

```lua
cmd = {'<path_to_reason_language_server>'}

```
]],
  },
}

