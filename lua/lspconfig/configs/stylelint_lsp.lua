local util = require 'lspconfig.util'

local root_file = {
  '.stylelintrc',
  '.stylelintrc.mjs',
  '.stylelintrc.cjs',
  '.stylelintrc.js',
  '.stylelintrc.json',
  '.stylelintrc.yaml',
  '.stylelintrc.yml',
  'stylelint.config.mjs',
  'stylelint.config.cjs',
  'stylelint.config.js',
}

root_file = util.insert_package_json(root_file, 'stylelint')

return {
  default_config = {
    cmd = { 'stylelint-lsp', '--stdio' },
    filetypes = {
      'astro',
      'css',
      'html',
      'less',
      'scss',
      'sugarss',
      'vue',
      'wxss',
    },
    root_dir = util.root_pattern(unpack(root_file)),
    settings = {},
  },
  docs = {
    description = [[
https://github.com/bmatcuk/stylelint-lsp

`stylelint-lsp` can be installed via `npm`:

```sh
npm i -g stylelint-lsp
```

Can be configured by passing a `settings.stylelintplus` object to `stylelint_lsp.setup`:

```lua
require'lspconfig'.stylelint_lsp.setup{
  settings = {
    stylelintplus = {
      -- see available options in stylelint-lsp documentation
    }
  }
}
```
]],
  },
}
