return {
  default_config = {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 'vmasm' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/bergercookie/asm-lsp

Language Server for GAS/GO Assembly

`asm-lsp` can be installed via cargo:
cargo install asm-lsp
]],
  },
}
