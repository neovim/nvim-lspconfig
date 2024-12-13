return {
  default_config = {
    cmd = { 'roc_language_server' },
    filetypes = { 'roc' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/roc-lang/roc/tree/main/crates/language_server#roc_language_server

The built-in language server for the Roc programming language.
[Installation](https://github.com/roc-lang/roc/tree/main/crates/language_server#installing)
]],
  },
}
