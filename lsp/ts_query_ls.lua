---@brief
---
--- https://github.com/ribru17/ts_query_ls
--- Can be configured by passing a "settings" object to `vim.lsp.config('ts_query_ls', {})`:
--- ```lua
--- vim.lsp.config('ts_query_ls', {
---     settings = {
---       parser_install_directories = {
---         -- If using nvim-treesitter with lazy.nvim
---         vim.fs.joinpath(
---           vim.fn.stdpath('data'),
---           '/lazy/nvim-treesitter/parser/'
---         ),
---       },
---       -- This setting is provided by default
---       parser_aliases = {
---         ecma = 'javascript',
---         jsx = 'javascript',
---         php_only = 'php',
---       },
---       -- E.g. zed support
---       language_retrieval_patterns = {
---         'languages/src/([^/]+)/[^/]+\\.scm$',
---       },
---     },
--- })
--- ```
return {
  cmd = { 'ts_query_ls' },
  filetypes = { 'query' },
  root_markers = { 'queries', '.git' },
  settings = {
    parser_aliases = {
      ecma = 'javascript',
      jsx = 'javascript',
      php_only = 'php',
    },
  },
}
