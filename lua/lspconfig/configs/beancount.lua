return {
  default_config = {
    cmd = { 'beancount-language-server', '--stdio' },
    filetypes = { 'beancount', 'bean' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    init_options = {},
  },
  docs = {
    description = [[
https://github.com/polarmutex/beancount-language-server#installation

See https://github.com/polarmutex/beancount-language-server#configuration for configuration options
]],
  },
}
