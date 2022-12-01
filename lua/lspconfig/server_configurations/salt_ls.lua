local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'salt_lsp_server' },
    filetypes = { 'sls' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
Language server for Salt configuration files.
https://github.com/dcermak/salt-lsp

The language server can be installed with `pip`:
```sh
pip install salt-lsp
```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
