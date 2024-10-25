local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ts_query_ls' },
    filetypes = { 'query' },
    root_dir = util.root_pattern('queries', '.git'),
    settings = {
      parser_aliases = {
        ecma = 'javascript',
        jsx = 'javascript',
        php_only = 'php',
      },
    },
  },
  docs = {
    description = [[
https://github.com/ribru17/ts_query_ls
Can be configured by passing a "settings" object to `ts_query_ls.setup{}`:
```lua
require('lspconfig').ts_query_ls.setup{
    settings = {
      parser_install_directories = {
        -- If using nvim-treesitter with lazy.nvim
        vim.fs.joinpath(
          vim.fn.stdpath('data'),
          '/lazy/nvim-treesitter/parser/'
        ),
      },
      -- This setting is provided by default
      parser_aliases = {
        ecma = 'javascript',
        jsx = 'javascript',
        php_only = 'php',
      },
      -- E.g. zed support
      language_retrieval_patterns = {
        'languages/src/([^/]+)/[^/]+\\.scm$',
      },
    },
}
```
]],
  },
}
