local util = require 'lspconfig.util'

local bin_name = 'graphql-lsp'
local cmd = { bin_name, 'server', '-m', 'stream' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'server', '-m', 'stream' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'graphql', 'typescriptreact', 'javascriptreact' },
    root_dir = util.root_pattern('.git', '.graphqlrc*', '.graphql.config.*', 'graphql.config.*'),
  },

  docs = {
    description = [[
https://github.com/graphql/graphiql/tree/main/packages/graphql-language-service-cli

`graphql-lsp` can be installed via `npm`:

```sh
npm install -g graphql-language-service-cli
```
]],
    default_config = {
      root_dir = [[root_pattern('.git', '.graphqlrc*', '.graphql.config.*')]],
    },
  },
}
