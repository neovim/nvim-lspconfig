local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'fennel-ls' },
    filetypes = { 'fennel' },
    root_dir = function(dir)
      local has_fls_project_cfg = function(path)
        return util.path.is_file(vim.fs.joinpath(path, 'flsproject.fnl'))
      end
      return util.search_ancestors(dir, has_fls_project_cfg) or vim.fs.root(0, '.git')
    end,
    settings = {},
    capabilities = {
      offsetEncoding = { 'utf-8', 'utf-16' },
    },
  },
  docs = {
    description = [[
https://sr.ht/~xerool/fennel-ls/

A language server for fennel.

fennel-ls is configured using the closest file to your working directory named `flsproject.fnl`.
All fennel-ls configuration options [can be found here](https://git.sr.ht/~xerool/fennel-ls/tree/HEAD/docs/manual.md#configuration).
]],
  },
}
