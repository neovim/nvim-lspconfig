---@brief
---
--- https://github.com/xna00/unocss-language-server
---
--- UnoCSS Language Server can be installed via npm:
--- ```sh
--- npm i unocss-language-server -g
--- ```
return {
  cmd = { 'unocss-language-server', '--stdio' },
  -- copied from https://github.com/unocss/unocss/blob/35297359bf61917bda499db86e3728a7ebd05d6c/packages/vscode/src/autocomplete.ts#L12-L35
  filetypes = {
    'erb',
    'haml',
    'hbs',
    'html',
    'css',
    'postcss',
    'javascript',
    'javascriptreact',
    'markdown',
    'ejs',
    'php',
    'svelte',
    'typescript',
    'typescriptreact',
    'vue-html',
    'vue',
    'sass',
    'scss',
    'less',
    'stylus',
    'astro',
    'rescript',
    'rust',
  },
  workspace_required = true,
  root_markers = { 'unocss.config.js', 'unocss.config.ts', 'uno.config.js', 'uno.config.ts' },
}
