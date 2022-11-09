local util = require 'lspconfig.util'

local bin_name = 'graphql-lsp'
local cmd = { bin_name, 'server', '-m', 'stream' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'server', '-m', 'stream' }
end

local workspace_markers = { '.git', '.graphqlrc*', '.graphql.config.*', 'graphql.config.*' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'graphql', 'typescriptreact', 'javascriptreact' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },

  docs = {
    description = [[
https://github.com/graphql/graphiql/tree/main/packages/graphql-language-service-cli

`graphql-lsp` can be installed via `npm`:

```sh
npm install -g graphql-language-service-cli
```

Note that you must also have [the graphql package](https://github.com/graphql/graphql-js) installed and create a [GraphQL config file](https://www.graphql-config.com/docs/user/user-introduction).
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
