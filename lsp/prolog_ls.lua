---@brief
---
--- https://github.com/jamesnvc/lsp_server
---
--- Language Server Protocol server for SWI-Prolog
return {
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
  root_markers = { 'pack.pl' },
}
