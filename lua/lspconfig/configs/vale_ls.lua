return {
  default_config = {
    cmd = { 'vale-ls' },
    filetypes = { 'markdown', 'text', 'tex', 'rst' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.vale.ini' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/errata-ai/vale-ls

An implementation of the Language Server Protocol (LSP) for the Vale command-line tool.
]],
  },
}
