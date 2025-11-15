-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
return {
  default_config = {
    cmd = { 'wat_server' },
    filetypes = { 'wat' },
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/g-plane/wasm-language-tools

WebAssembly Language Tools aims to provide and improve the editing experience of WebAssembly Text Format.
It also provides an out-of-the-box formatter (a.k.a. pretty printer) for WebAssembly Text Format.
]],
  },
}
