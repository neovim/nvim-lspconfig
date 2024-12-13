return {
  default_config = {
    cmd = { 'koka', '--language-server', '--lsstdio' },
    filetypes = { 'koka' },
    single_file_support = true,
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },

  docs = {
    description = [[
    https://koka-lang.github.io/koka/doc/index.html
Koka is a functional programming language with effect types and handlers.
    ]],
  },
}
