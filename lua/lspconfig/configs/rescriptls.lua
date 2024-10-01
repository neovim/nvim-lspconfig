local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'rescript-language-server', '--stdio' },
    filetypes = { 'rescript' },
    root_dir = util.root_pattern('bsconfig.json', 'rescript.json', '.git'),
    settings = {},
    init_options = {
      extensionConfiguration = {
        -- buggy, prompts much too often, superseded by incrementalTypechecking, below
        askToStartBuild = false,

        allowBuiltInFormatter = true, -- lower latency
        incrementalTypechecking = { -- removes the need for external build process
          enabled = true,
          acrossFiles = true,
        },
        cache = { projectConfig = { enabled = true } }, -- speed up latency dramatically
        codeLens = true,
        inlayHints = { enable = true },
      },
    },
  },
  docs = {
    description = [[
https://github.com/rescript-lang/rescript-vscode/tree/master/server

ReScript Language Server can be installed via npm:
```sh
npm install -g @rescript/language-server
```

See [package.json](https://github.com/rescript-lang/rescript-vscode/blob/master/package.json#L139)
for init_options supported.

For example, in order to disable the `inlayHints` option:
```lua
require'lspconfig'.pylsp.setup{
  settings = {
    rescript = {
      settings = {
        inlayHints = { enable = false },
      },
    },
  }
}
```
]],
    root_dir = [[root_pattern('bsconfig.json', 'rescript.json', '.git')]],
  },
}
