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
    'astro',
    'css',
    'eruby',
    'html',
    'htmlangular',
    'htmldjango',
    'javascriptreact',
    'less',
    'pug',
    'sass',
    'scss',
    'svelte',
    'templ',
    'typescriptreact',
    'vue',
  },
  root_markers = { '.git' },
}
