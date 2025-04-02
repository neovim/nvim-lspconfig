local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ada_language_server' },
    filetypes = { 'ada' },
    root_dir = util.root_pattern('Makefile', '.git', 'alire.toml', '*.gpr', '*.adc'),
  },
  docs = {
    description = [[
https://github.com/AdaCore/ada_language_server

Installation instructions can be found [here](https://github.com/AdaCore/ada_language_server#Install).

Workspace-specific [settings](https://github.com/AdaCore/ada_language_server/blob/master/doc/settings.md) such as `projectFile` can be provided in a `.als.json` file at the root of the workspace.

Alternatively, configuration may be passed as a "settings" object to `ada_ls.setup{}`:

```lua
require('lspconfig').ada_ls.setup{
    settings = {
      ada = {
        projectFile = "project.gpr";
        scenarioVariables = { ... };
      }
    }
}
```
]],
  },
}
