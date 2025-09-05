---@brief
---
--- https://github.com/ribru17/ts_query_ls
--- Can be configured by passing a "settings" object to `vim.lsp.config('ts_query_ls', {})`:
--- ```lua
--- vim.lsp.config('ts_query_ls', {
---   init_options = {
---     parser_install_directories = {
---       '/my/parser/install/dir',
---     },
---     -- This setting is provided by default
---     parser_aliases = {
---       ecma = 'javascript',
---       jsx = 'javascript',
---       php_only = 'php',
---     },
---   },
--- })
--- ```

-- Disable the (slow) built-in query linter, which will show duplicate diagnostics. This must be done before the query
-- ftplugin is sourced.
vim.g.query_lint_on = {}

---@type vim.lsp.Config
return {
  cmd = { 'ts_query_ls' },
  filetypes = { 'query' },
  root_markers = { '.tsqueryrc.json', '.git' },
  init_options = {
    parser_aliases = {
      ecma = 'javascript',
      jsx = 'javascript',
      php_only = 'php',
    },
    parser_install_directories = {
      vim.fn.stdpath('data') .. '/site/parser',
    },
  },
  on_attach = function(_, buf)
    vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end,
}
