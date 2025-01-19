return {
  default_config = {
    cmd = { 'tblgen-lsp-server' },
    filetypes = { 'tablegen' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find({ 'tablegen_compile_commands.yml', '.git' }, { path = fname, upward = true })[1]
      )
    end,
  },
  docs = {
    description = [[
https://mlir.llvm.org/docs/Tools/MLIRLSP/#tablegen-lsp-language-server--tblgen-lsp-server

The Language Server for the LLVM TableGen language

`tblgen-lsp-server` can be installed at the llvm-project repository (https://github.com/llvm/llvm-project)
]],
  },
}
