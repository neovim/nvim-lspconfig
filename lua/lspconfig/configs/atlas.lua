local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'atlas', 'tool', 'lsp', '--stdio' },
    filetypes = {
      'atlas-*',
    },
    root_dir = function(fname)
      return util.root_pattern('atlas.hcl')(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/ariga/atlas

Language server for Atlas config and scheme files.

You may also need to configure the filetype for *.hcl files:

`autocmd BufNewFile,BufRead atlas.hcl set filetype=atlas-config`
`autocmd BufNewFile,BufRead *.my.hcl set filetype=atlas-schema-mysql`
`autocmd BufNewFile,BufRead *.pg.hcl set filetype=atlas-schema-postgresql`
`autocmd BufNewFile,BufRead *.lt.hcl set filetype=atlas-schema-sqlite`
`autocmd BufNewFile,BufRead *.ch.hcl set filetype=atlas-schema-clickhouse`
`autocmd BufNewFile,BufRead *.ms.hcl set filetype=atlas-schema-mssql`
`autocmd BufNewFile,BufRead *.rs.hcl set filetype=atlas-schema-redshift`
`autocmd BufNewFile,BufRead *.test.hcl set filetype=atlas-test`
`autocmd BufNewFile,BufRead *.plan.hcl set filetype=atlas-plan`

]],
  },
}
