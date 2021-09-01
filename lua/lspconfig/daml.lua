local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.daml = {
  default_config = {
    cmd = { 'daml', 'ide' },
    filetypes = { 'daml' },
    root_dir = util.root_pattern('daml.yaml'),
  },

  docs = {
    description = [[
https://daml.com

The Daml distributed applications language.

You can install the Daml language server with

```bash
curl -sSL https://get.daml.com/ | sh`
```
]],
    default_config = {
      root_dir = [[root_pattern("daml.yaml")]],
    },
  },
}
