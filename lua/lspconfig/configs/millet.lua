-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'millet' },
    filetypes = { 'sml' },
    root_dir = util.root_pattern 'millet.toml',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/azdavis/millet

Millet, a language server for Standard ML

To use with nvim:

1. Install a Rust toolchain: https://rustup.rs
2. Clone the repo
3. Run `cargo build --release --bin millet-ls`
4. Move `target/release/millet-ls` to somewhere on your $PATH as `millet`
    ]],
  },
}
