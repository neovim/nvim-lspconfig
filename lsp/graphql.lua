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

return {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  filetypes = { 'graphql', 'typescriptreact', 'javascriptreact' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name, _)
      local patterns = { '.graphqlrc*', '.graphql.config.*', 'graphql.config.*' }
      for _, pattern in ipairs(patterns) do
        if vim.glob.to_lpeg(pattern):match(name) ~= nil then
          return true
        end
      end
      return false
    end))
  end,
}
