---@brief
---
--- https://github.com/graphql/graphiql/tree/main/packages/graphql-language-service-cli
---
--- `graphql-lsp` can be installed via `npm`:
---
--- ```sh
--- npm install -g graphql-language-service-cli
--- ```
---
--- Note that you must also have [the graphql package](https://github.com/graphql/graphql-js) installed within your project and create a [GraphQL config file](https://the-guild.dev/graphql/config/docs).

local util = require 'lspconfig.util'

return {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  filetypes = { 'graphql', 'typescriptreact', 'javascriptreact' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern('.graphqlrc*', '.graphql.config.*', 'graphql.config.*')(fname))
  end,
}
