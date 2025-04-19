---@brief
---
--- https://github.com/antonk52/lua-3p-language-servers
---
--- 3rd party Language Server for Stylua lua formatter
return {
  cmd = { 'stylua-3p-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.stylua.toml', 'stylua.toml' },
}
