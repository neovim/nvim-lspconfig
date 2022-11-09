local util = require 'lspconfig.util'

local workspace_markers = { '.flowconfig' }

return {
  default_config = {
    cmd = { 'npx', '--no-install', 'flow', 'lsp' },
    filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://flow.org/
https://github.com/facebook/flow

See below for how to setup Flow itself.
https://flow.org/en/docs/install/

See below for lsp command options.

```sh
npx flow lsp --help
```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
