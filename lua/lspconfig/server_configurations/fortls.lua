local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {
      'fortls',
      '--notify_init',
      '--hover_signature',
      '--hover_language=fortran',
      '--use_signature_help',
    },
    filetypes = { 'fortran' },
    root_dir = function(fname)
      return util.root_pattern '.fortls'(fname) or util.find_git_ancestor(fname)
    end,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/gnikit/fortls

fortls - Fortran Language Server
    ]],
    default_config = {
      root_dir = [[root_pattern(".fortls")]],
    },
  },
}
