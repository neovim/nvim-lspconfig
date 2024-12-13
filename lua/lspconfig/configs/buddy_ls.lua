return {
  default_config = {
    cmd = { 'buddy-lsp-server' },
    filetypes = { 'mlir' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/buddy-compiler/buddy-mlir#buddy-lsp-server
The Language Server for the buddy-mlir, a drop-in replacement for mlir-lsp-server,
supporting new dialects defined in buddy-mlir.
`buddy-lsp-server` can be installed at the buddy-mlir repository (buddy-compiler/buddy-mlir)
]],
  },
}
