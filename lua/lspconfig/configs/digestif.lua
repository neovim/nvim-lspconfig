return {
  default_config = {
    cmd = { 'digestif' },
    filetypes = { 'tex', 'plaintex', 'context' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/astoff/digestif

Digestif is a code analyzer, and a language server, for LaTeX, ConTeXt et caterva. It provides

context-sensitive completion, documentation, code navigation, and related functionality to any

text editor that speaks the LSP protocol.
]],
  },
}
