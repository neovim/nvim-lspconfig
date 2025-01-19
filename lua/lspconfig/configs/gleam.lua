return {
  default_config = {
    cmd = { 'gleam', 'lsp' },
    filetypes = { 'gleam' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'gleam.toml', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/gleam-lang/gleam

A language server for Gleam Programming Language.
[Installation](https://gleam.run/getting-started/installing/)

It can be i
]],
  },
}
