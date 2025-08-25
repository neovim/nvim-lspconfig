---@brief
---
--- https://github.com/bergercookie/asm-lsp
---
--- Language Server for NASM/GAS/GO Assembly
---
--- `asm-lsp` can be installed via cargo:
--- cargo install asm-lsp

---@type vim.lsp.Config
return {
  cmd = { 'asm-lsp' },
  filetypes = { 'asm', 'vmasm' },
  root_markers = { '.asm-lsp.toml', '.git' },
}
