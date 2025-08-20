---@brief
--- https://github.com/hirosystems/clarinet
---
--- Clarinet is the fastest way to build, test, and deploy smart contracts on the Stacks blockchain.

---@type vim.lsp.Config
return {
  cmd = { 'clarinet', 'lsp' },
  filetypes = { 'clar', 'clarity' },
  root_markers = { 'Clarinet.toml' },
}
