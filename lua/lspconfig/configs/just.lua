return {
  default_config = {
    cmd = { 'just-lsp' },
    filetypes = { 'just' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/terror/just-lsp

`just-lsp` is an LSP for just built on top of the tree-sitter-just parser.
]],
  },
}
