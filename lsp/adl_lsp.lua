---@brief
---
--- https://github.com/alexytsu/adl-lsp
---
--- ADL Language server is a language server for [Algebraic Data Language](https://github.com/adl-lang/adl), written in Rust.
---
---
--- It can be installed via cargo:
--- ```sh
--- cargo install adl-lsp
--- ```

return {
  cmd = { 'adl-lsp' },
  filetypes = { 'adl', 'adl-cpp', 'adl-hs', 'adl-java', 'adl-hs', 'adl-rs', 'adl-ts' },
  root_markers = { '.git' },
}
