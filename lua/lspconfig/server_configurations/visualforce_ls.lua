local util = require 'lspconfig.util'

local workspace_markers = { 'sfdx-project.json' }

return {
  default_config = {
    filetypes = { 'visualforce' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    init_options = {
      embeddedLanguages = {
        css = true,
        javascript = true,
      },
    },
  },
  docs = {
    description = [[
https://github.com/forcedotcom/salesforcedx-vscode

Language server for Visualforce.

For manual installation, download the .vsix archive file from the
[forcedotcom/salesforcedx-vscode](https://github.com/forcedotcom/salesforcedx-vscode)
GitHub releases. Then, configure `cmd` to run the Node script at the unpacked location:

```lua
require'lspconfig'.visualforce_ls.setup {
  cmd = {
    'node',
    '/path/to/unpacked/archive/extension/node_modules/@salesforce/salesforcedx-visualforce-language-server/out/src/visualforceServer.js',
    '--stdio'
  }
}
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
