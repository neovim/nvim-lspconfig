---@brief
---
--- https://github.com/salesforce/agentscript
---
--- Language server for Agent Script, Salesforce's open agent specification
--- language for `*.agent` files. Install with
--- `npm install -g @sf-agentscript/lsp-server`.
---
--- Neovim does not detect the `agentscript` filetype by default:
---
--- ```lua
--- vim.filetype.add({ extension = { agent = 'agentscript' } })
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'agentscript-lsp', '--stdio' },
  filetypes = { 'agentscript' },
  root_markers = { 'package.json', '.git' },
}
