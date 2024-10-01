local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ziggy', 'lsp', '--schema' },
    filetypes = { 'ziggy_schema' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://ziggy-lang.io/documentation/ziggy-lsp/

Language server for schema files of the Ziggy data serialization format

]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
