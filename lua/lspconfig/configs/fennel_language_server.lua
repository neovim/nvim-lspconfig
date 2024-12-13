return {
  default_config = {
    cmd = { 'fennel-language-server' },
    filetypes = { 'fennel' },
    single_file_support = true,
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/rydesun/fennel-language-server

Fennel language server protocol (LSP) support.
]],
  },
}
