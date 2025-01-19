return {
  default_config = {
    cmd = { 'standardrb', '--lsp' },
    filetypes = { 'ruby' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'Gemfile', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/testdouble/standard

Ruby Style Guide, with linter & automatic code fixer.
    ]],
  },
}
