return {
  default_config = {
    cmd = { 'aiken', 'lsp' },
    filetypes = { 'aiken' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'aiken.toml', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/aiken-lang/aiken

A language server for Aiken Programming Language.
[Installation](https://aiken-lang.org/installation-instructions)

It can be i
]],
  },
}
