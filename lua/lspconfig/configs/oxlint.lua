local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'oxc_language_server' },
    filetypes = {
      'astro',
      'javascript',
      'javascriptreact',
      'svelte',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
      'vue',
    },
    root_dir = util.root_pattern('.oxlintrc.json'),
    single_file_support = false,
  },
  docs = {
    description = [[
https://oxc.rs

A collection of JavaScript tools written in Rust.

```sh
npm install [-g] oxlint
```
]],
  },
}
