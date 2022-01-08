local util = require 'lspconfig.util'

return {
  default_config = {
    -- `foam-ls` can be a shell script executing:
    -- node /path/to/foam-language-server/lib/foam-ls.js --stdio
    cmd = { 'foam-ls' },
    filetypes = { 'foam', 'OpenFOAM' },
    root_dir = util.root_pattern('system/controlDict'),
    log_level = vim.lsp.protocol.MessageType.Warning,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/FoamScience/foam-language-server/master/package.json',
    description = [[
https://github.com/FoamScience/foam-language-server

`foam-language-server` can be installed via `npm`
```sh
npm install -g foam-language-server
```
]],
    default_config = {
      root_dir = [[root_pattern("system/controlDict")]],
    },
  },
}
