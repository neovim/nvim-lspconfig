local util = require 'lspconfig.util'

local workspace_markers = { '*.nimble', '.git' }

return {
  default_config = {
    cmd = { 'nimlsp' },
    filetypes = { 'nim' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/PMunch/nimlsp

`nimlsp` can be installed via the `nimble` package manager:

```sh
nimble install nimlsp
```
    ]],
    workspace_markers = workspace_markers,
  },
}
