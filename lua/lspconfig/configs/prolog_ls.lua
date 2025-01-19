return {
  default_config = {
    cmd = {
      'swipl',
      '-g',
      'use_module(library(lsp_server)).',
      '-g',
      'lsp_server:main',
      '-t',
      'halt',
      '--',
      'stdio',
    },
    filetypes = { 'prolog' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'pack.pl' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
  https://github.com/jamesnvc/lsp_server

  Language Server Protocol server for SWI-Prolog
  ]],
  },
}
