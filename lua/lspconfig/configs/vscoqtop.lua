local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'vscoqtop' },
    filetypes = { 'coq' },
    root_dir = function(fname)
      return util.root_pattern '_CoqProject'(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/coq-community/vscoq
]],
  },
}
