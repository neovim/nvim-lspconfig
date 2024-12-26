local util = require 'lspconfig.util'

local root_files = {
  'cue.mod',
  '.git',
}

return {
  default_config = {
    cmd = { 'cue', 'lsp' },
    filetypes = { 'cue' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/cue-lang/cue

CUE makes it easy to validate data, write schemas, and ensure configurations align with policies.
]],
  },
}
