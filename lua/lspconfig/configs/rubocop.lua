return {
  default_config = {
    cmd = { 'rubocop', '--lsp' },
    filetypes = { 'ruby' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'Gemfile', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/rubocop/rubocop
    ]],
  },
}
