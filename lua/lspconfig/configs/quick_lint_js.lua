return {
  default_config = {
    cmd = { 'quick-lint-js', '--lsp-server' },
    filetypes = { 'javascript', 'typescript' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find({ 'package.json', 'jsconfig.json', '.git' }, { path = fname, upward = true })[1]
      )
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://quick-lint-js.com/

quick-lint-js finds bugs in JavaScript programs.

See installation [instructions](https://quick-lint-js.com/install/)
]],
  },
}
