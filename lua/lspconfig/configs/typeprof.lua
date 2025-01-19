return {
  default_config = {
    cmd = { 'typeprof', '--lsp', '--stdio' },
    filetypes = { 'ruby', 'eruby' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'Gemfile', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/ruby/typeprof

`typeprof` is the built-in analysis and LSP tool for Ruby 3.1+.
    ]],
  },
}
