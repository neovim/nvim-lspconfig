local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 'vmasm' },
    single_file_support = true,
    root_dir = function(fname)
      return util.root_pattern('.asm-lsp.toml')(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/bergercookie/asm-lsp

Language Server for NASM/GAS/GO Assembly

`asm-lsp` can be installed via cargo:
cargo install asm-lsp
]],
  },
}
