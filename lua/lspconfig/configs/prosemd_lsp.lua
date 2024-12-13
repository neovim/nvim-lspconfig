return {
  default_config = {
    cmd = { 'prosemd-lsp', '--stdio' },
    filetypes = { 'markdown' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/kitten/prosemd-lsp

An experimental LSP for Markdown.

Please see the manual installation instructions: https://github.com/kitten/prosemd-lsp#manual-installation
]],
  },
}
