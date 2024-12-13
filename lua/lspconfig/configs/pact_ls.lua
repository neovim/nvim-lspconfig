return {
  default_config = {
    cmd = { 'pact-lsp' },
    filetypes = { 'pact' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/kadena-io/pact-lsp

The Pact language server
    ]],
  },
}
