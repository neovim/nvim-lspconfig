local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'snakeskin-cli', 'lsp', '--stdio' },
    filetypes = { 'ss' },
    root_dir = util.root_pattern 'package.json',
  },
  docs = {
    description = [[
https://www.npmjs.com/package/@snakeskin/cli

`snakeskin cli` can be installed via `npm`:
```sh
npm install -g @snakeskin/cli
```
]],
  },
}
