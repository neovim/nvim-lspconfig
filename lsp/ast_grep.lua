---@brief
---
-- https://ast-grep.github.io/
--
-- ast-grep(sg) is a fast and polyglot tool for code structural search, lint, rewriting at large scale.
-- ast-grep LSP only works in projects that have `sgconfig.y[a]ml` in their root directories.
-- ```sh
-- npm install [-g] @ast-grep/cli
-- ```
return {
  cmd = { 'ast-grep', 'lsp' },
  filetypes = { -- https://ast-grep.github.io/reference/languages.html
    'c',
    'cpp',
    'rust',
    'go',
    'java',
    'python',
    'javascript',
    'typescript',
    'html',
    'css',
    'kotlin',
    'dart',
    'lua',
  },
  root_markers = { 'sgconfig.yaml', 'sgconfig.yml' },
}
