local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'air', 'language-server' },
    filetypes = { 'r' },
    root_dir = function(fname)
      return util.root_pattern('air.toml', '.air.toml')(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/posit-dev/air

Air is an R formatter and language server, written in Rust.

Refer to the [documentation](https://posit-dev.github.io/air/editors.html) for more details.

  ]],
  },
}
