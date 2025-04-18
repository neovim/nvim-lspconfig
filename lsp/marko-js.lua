---@brief
---
--- https://github.com/marko-js/language-server
---
--- Using the Language Server Protocol to improve Marko's developer experience.
---
--- Can be installed via npm:
--- ```
--- npm i -g @marko/language-server
--- ```
return {
  cmd = { 'marko-language-server', '--stdio' },
  filetypes = { 'marko' },
  root_markers = { '.git' },
}
