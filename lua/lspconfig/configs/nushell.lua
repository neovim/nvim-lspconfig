return {
  default_config = {
    cmd = { 'nu', '--lsp' },
    filetypes = { 'nu' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1] or fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/nushell/nushell

Nushell built-in language server.
]],
  },
}
