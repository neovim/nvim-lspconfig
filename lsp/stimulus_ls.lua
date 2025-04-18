---@brief
---
--- https://www.npmjs.com/package/stimulus-language-server
---
--- `stimulus-lsp` can be installed via `npm`:
---
--- ```sh
--- npm install -g stimulus-language-server
--- ```
---
--- or via `yarn`:
---
--- ```sh
--- yarn global add stimulus-language-server
--- ```
return {
  cmd = { 'stimulus-language-server', '--stdio' },
  filetypes = { 'html', 'ruby', 'eruby', 'blade', 'php' },
  root_markers = { 'Gemfile', '.git' },
}
