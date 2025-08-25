---@brief
---
--- https://www.mint-lang.com
---
--- Install Mint using the [instructions](https://www.mint-lang.com/install).
--- The language server is included since version 0.12.0.

---@type vim.lsp.Config
return {
  cmd = { 'mint', 'ls' },
  filetypes = { 'mint' },
  root_markers = { 'mint.json', '.git' },
}
