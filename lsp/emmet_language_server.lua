---@brief
---
--- https://github.com/olrtg/emmet-language-server
---
--- Package can be installed via `npm`:
--- ```sh
--- npm install -g @olrtg/emmet-language-server
--- ```
return {
  cmd = { 'emmet-language-server', '--stdio' },
  filetypes = {
    'css',
    'eruby',
    'html',
    'htmldjango',
    'javascriptreact',
    'less',
    'pug',
    'sass',
    'scss',
    'typescriptreact',
    'htmlangular',
  },
  root_markers = { '.git' },
}
