return {
  default_config = {
    cmd = { 'kulala-ls', '--stdio' },
    filetypes = { 'http' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/mistweaverco/kulala-ls

A minimal language server for HTTP syntax.
]],
  },
}
