-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
return {
  default_config = {
    cmd = { 'air', 'language-server' },
    filetypes = { 'r' },
    root_dir = vim.fs.root(0, { 'air.toml', '.air.toml', '.git' }),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/posit-dev/air

Air is an R formatter and language server, written in Rust.

Refer to the [documentation](https://posit-dev.github.io/air/editors.html) for more details.

  ]],
  },
}
