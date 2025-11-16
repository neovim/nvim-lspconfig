-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
return {
  default_config = {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 'vmasm' },
    single_file_support = true,
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.asm-lsp.toml', '.git' }, { path = fname, upward = true })[1])
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
