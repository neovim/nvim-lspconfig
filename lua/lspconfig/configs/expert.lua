local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
    cmd = { 'expert' },
    root_dir = function(fname)
      return util.root_pattern 'mix.exs'(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/elixir-expert/expert

Expert is the official language server implementation for the Elixir programming language.
]],
  },
}
