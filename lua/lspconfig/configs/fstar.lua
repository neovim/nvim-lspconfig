return {
  default_config = {
    cmd = { 'fstar.exe', '--lsp' },
    filetypes = { 'fstar' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/FStarLang/FStar

LSP support is included in FStar. Make sure `fstar.exe` is in your PATH.
]],
  },
}
