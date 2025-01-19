return {
  default_config = {
    cmd = { 'als' },
    filetypes = { 'agda' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.git', '*.agda-lib' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/agda/agda-language-server

Language Server for Agda.
]],
  },
}
