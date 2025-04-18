---@brief
---
--- https://github.com/azdavis/millet
---
--- Millet, a language server for Standard ML
---
--- To use with nvim:
---
--- 1. Install a Rust toolchain: https://rustup.rs
--- 2. Clone the repo
--- 3. Run `cargo build --release --bin lang-srv`
--- 4. Move `target/release/lang-srv` to somewhere on your $PATH as `millet`
return {
  cmd = { 'millet' },
  filetypes = { 'sml' },
  root_markers = { 'millet.toml' },
}
