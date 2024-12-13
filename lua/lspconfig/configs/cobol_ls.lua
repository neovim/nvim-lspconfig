return {
  default_config = {
    cmd = { 'cobol-language-support' },
    filetypes = { 'cobol' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
Cobol language support
    ]],
  },
}
