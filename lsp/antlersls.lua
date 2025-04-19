---@brief
---
--- https://www.npmjs.com/package/antlers-language-server
---
--- `antlersls` can be installed via `npm`:
--- ```sh
--- npm install -g antlers-language-server
--- ```
return {
  cmd = { 'antlersls', '--stdio' },
  filetypes = { 'html', 'antlers' },
  root_markers = { 'composer.json' },
}
