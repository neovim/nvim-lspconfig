---@brief
---
--- https://github.com/antonk52/lua-3p-language-servers
---
--- 3rd party Language Server for Selene lua linter
return {
  cmd = { 'selene-3p-language-server' },
  filetypes = { 'lua' },
  root_markers = { 'selene.toml' },
}
