return {
  default_config = {
    filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'mix.exs', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/elixir-tools/next-ls

**By default, next-ls does not set its `cmd`. Please see the following [detailed instructions](https://www.elixir-tools.dev/docs/next-ls/installation/) for possible installation methods.**
]],
  },
}
