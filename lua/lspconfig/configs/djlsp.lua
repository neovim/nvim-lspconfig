local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'djlsp' },
    filetypes = { 'html', 'htmldjango' },
    root_dir = util.find_git_ancestor,
    settings = {},
  },
  docs = {
    description = [[
      https://github.com/fourdigits/django-template-lsp

      `djlsp`, a language server for Django templates.
    ]],
  },
}
