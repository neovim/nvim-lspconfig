local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {},
    filetypes = { 'yaml' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/microsoft/azure-pipelines-language-server

An Azure Pipelines language server

**By default, `azure-pipelines-language-server` doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path.
You have to install the language server manually.

`azure-pipelines-language-server` can be installed via `npm`:

```sh
npm install -g azure-pipelines-language-server
```

Once installed, point `cmd` to `server.js` inside the `server/out` directory:

```lua
cmd = {'node', '<path_to_repo>/server/out/server.js', '--stdio'}
```

By default `azure-pipelines-language-server` will only work in files named `azure-pipelines.yml`, this can be changed by providing additional settings like so:
```lua
require("lspconfig").azure_pipelines_language_server.setup {
  ... -- other configuration for setup {}
  settings = {
      yaml = {
          schemas = {
              ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
                  "/azure-pipeline*.y*l",
                  "/*.azure*",
                  "Azure-Pipelines/**/*.y*l",
                  "Pipelines/*.y*l",
              },
          },
      },
  },
}
```
The Azure Pipelines LSP is a fork of `yaml-language-server` and as such the same settings can be passed to it as `yaml-language-server`.
]],
  },
}
