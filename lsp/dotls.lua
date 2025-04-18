---@brief
---
--- https://github.com/nikeee/dot-language-server
---
--- `dot-language-server` can be installed via `npm`:
--- ```sh
--- npm install -g dot-language-server
--- ```
return {
  cmd = { 'dot-language-server', '--stdio' },
  filetypes = { 'dot' },
  root_markers = { '.git' },
}
