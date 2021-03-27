local configs = require('lspconfig/configs')
local util = require('lspconfig/util')

configs.stylelint_lsp = {
  default_config = {
    cmd = {'stylelint-lsp', '--stdio'},
    filetypes = {
      'css',
      'less',
      'scss',
      'sugarss',
      'vue',
      'wxss',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact'
    };
    root_dir = util.root_pattern('.stylelintrc', 'package.json');
    settings = {};
  },
  docs = {
    description = [[
https://github.com/bmatcuk/stylelint-lsp

`stylelint-lsp` can be installed via `npm`:

```sh
npm i -g stylelint-lsp
```
]];
    default_config = {
      root_dir = [[ root_pattern('.stylelintrc', 'package.json') ]];
    };
  };
}
