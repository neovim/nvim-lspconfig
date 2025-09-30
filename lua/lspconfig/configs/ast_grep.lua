local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ast-grep', 'lsp' },
    filetypes = { -- https://ast-grep.github.io/reference/languages.html
      'bash',
      'c',
      'cpp',
      'csharp',
      'css',
      'elixir',
      'go',
      'haskell',
      'html',
      'java',
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'json',
      'kotlin',
      'lua',
      'nix',
      'php',
      'python',
      'ruby',
      'rust',
      'scala',
      'solidity',
      'swift',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'yaml',
    },
    root_dir = util.root_pattern('sgconfig.yaml', 'sgconfig.yml'),
  },
  docs = {
    description = [[
https://ast-grep.github.io/

ast-grep(sg) is a fast and polyglot tool for code structural search, lint, rewriting at large scale.
ast-grep LSP only works in projects that have `sgconfig.y[a]ml` in their root directories.
```sh
npm install [-g] @ast-grep/cli
```
]],
  },
}
