local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ast-grep', 'lsp' },
    filetypes = { -- https://ast-grep.github.io/reference/languages.html
      'C',
      'C++',
      'Rust',
      'Go',
      'Java',
      'Python',
      'C#',
      'JavaScript',
      'JSX',
      'TypeScript',
      'HTML',
      'CSS',
      'Kotlin',
      'Dart',
      'Lua',
    },
    root_dir = util.root_pattern 'sgconfig.yaml',
    single_file_support = true,
  },
  docs = {
    description = [[
https://ast-grep.github.io/

ast-grep(sg) is a fast and polyglot tool for code structural search, lint, rewriting at large scale.

```sh
npm install [-g] @ast-grep/cli
```
]],
    default_config = {
      root_dir = [[root_pattern('sgconfig.yaml')]],
    },
  },
}
