-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
return {
  default_config = {
    cmd = { 'mlir-lsp-server' },
    filetypes = { 'mlir' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://mlir.llvm.org/docs/Tools/MLIRLSP/#mlir-lsp-language-server--mlir-lsp-server=

The Language Server for the LLVM MLIR language

`mlir-lsp-server` can be installed at the llvm-project repository (https://github.com/llvm/llvm-project)
]],
  },
}
