return {
  default_config = {
    cmd = { 'steep', 'langserver' },
    filetypes = { 'ruby', 'eruby' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'Steepfile', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/soutaro/steep

`steep` is a static type checker for Ruby.

You need `Steepfile` to make it work. Generate it with `steep init`.
]],
  },
}
