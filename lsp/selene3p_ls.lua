---@brief
---
--- https://github.com/antonk52/lua-3p-language-servers
---
--- 3rd party Language Server for Selene lua linter

---@type vim.lsp.Config
return {
  cmd = { 'selene-3p-language-server' },
  filetypes = { 'lua' },
  root_markers = { 'selene.toml' },
}
