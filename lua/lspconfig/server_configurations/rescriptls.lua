local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'rescript-language-server', '--stdio' },
    filetypes = { 'rescript' },
    root_dir = util.root_pattern('bsconfig.json', 'rescript.json', '.git'),
    settings = {},
  },
  docs = {
    description = [[
https://github.com/rescript-lang/rescript-vscode/tree/master/server
ReScript Language Server can be installed via npm:
```sh
npm install -g @rescript/language-server
```
]],
  },
}
