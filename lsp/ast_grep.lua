---@brief
---
--- https://ast-grep.github.io/
---
--- ast-grep(sg) is a fast and polyglot tool for code structural search, lint, rewriting at large scale.
--- ast-grep LSP only works in projects that have `sgconfig.y[a]ml` in their root directories.
--- ```sh
--- npm install [-g] @ast-grep/cli
--- ```
return {
  cmd = { 'ast-grep', 'lsp' },
  workspace_required = true,
  reuse_client = function(client, config)
    config.cmd_cwd = config.root_dir
    return client.config.cmd_cwd == config.cmd_cwd
  end,
  filetypes = { -- https://ast-grep.github.io/reference/languages.html
    'c',
    'cpp',
    'rust',
    'go',
    'java',
    'python',
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'html',
    'css',
    'kotlin',
    'dart',
    'lua',
  },
  root_markers = { 'sgconfig.yaml', 'sgconfig.yml' },
}
