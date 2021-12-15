local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'foam-ls' },
    filetypes = { 'foam', 'OpenFOAM' },
    root_dir = util.root_pattern('system'),
    log_level = vim.lsp.protocol.MessageType.Warning,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/FoamScience/foam-language-server/master/package.json',
    description = [[
https://github.com/FoamScience/foam-language-server

`foam-language-server` can be installed via `npm` (requires a sourced OpenFOAM installation):
```sh
npm install
```

Supported OpenFOAM forks/version:
    - Foam-Extend 4.0 and later
]],
    default_config = {
      root_dir = [[root_pattern("system")]],
    },
  },
}
