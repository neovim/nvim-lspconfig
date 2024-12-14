local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'crystalline' },
    filetypes = { 'crystal' },
    root_dir = function(fname)
      return util.root_pattern('shard.yml')(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/elbywan/crystalline

Crystal language server.
]],
  },
}
