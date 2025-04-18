---@brief
---
--- https://github.com/aca/emmet-ls
---
--- Package can be installed via `npm`:
--- ```sh
--- npm install -g emmet-ls
--- ```
return {
  cmd = { 'emmet-ls', '--stdio' },
  filetypes = {
    'astro',
    'css',
    'eruby',
    'html',
    'htmldjango',
    'javascriptreact',
    'less',
    'pug',
    'sass',
    'scss',
    'svelte',
    'typescriptreact',
    'vue',
    'htmlangular',
  },
  root_markers = { '.git' },
}
