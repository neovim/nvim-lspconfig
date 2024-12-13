return {
  default_config = {
    cmd = { 'typst-lsp' },
    filetypes = { 'typst' },
    single_file_support = true,
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/nvarner/typst-lsp

Language server for Typst.
    ]],
  },
}
