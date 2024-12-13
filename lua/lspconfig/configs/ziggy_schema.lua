return {
  default_config = {
    cmd = { 'ziggy', 'lsp', '--schema' },
    filetypes = { 'ziggy_schema' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://ziggy-lang.io/documentation/ziggy-lsp/

Language server for schema files of the Ziggy data serialization format

]],
  },
}
