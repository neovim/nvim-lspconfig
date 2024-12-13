return {
  default_config = {
    cmd = { 'pest-language-server' },
    filetypes = { 'pest' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/pest-parser/pest-ide-tools

Language server for pest grammars.
]],
  },
}
