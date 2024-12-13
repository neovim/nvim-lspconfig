return {
  default_config = {
    cmd = { 'djlsp' },
    filetypes = { 'html', 'htmldjango' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    settings = {},
  },
  docs = {
    description = [[
      https://github.com/fourdigits/django-template-lsp

      `djlsp`, a language server for Django templates.
    ]],
  },
}
