-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
return {
  default_config = {
    cmd = { 'mm0-rs', 'server' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    filetypes = { 'metamath-zero' },
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/digama0/mm0

Language Server for the metamath-zero theorem prover.

Requires [mm0-rs](https://github.com/digama0/mm0/tree/master/mm0-rs) to be installed
and available on the `PATH`.
    ]],
  },
}
