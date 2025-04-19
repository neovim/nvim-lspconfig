---@brief
---
--- https://github.com/phil294/coffeesense
---
--- CoffeeSense Language Server
--- `coffeesense-language-server` can be installed via `npm`:
--- ```sh
--- npm install -g coffeesense-language-server
--- ```
return {
  cmd = { 'coffeesense-language-server', '--stdio' },
  filetypes = { 'coffee' },
  root_markers = { 'package.json' },
}
