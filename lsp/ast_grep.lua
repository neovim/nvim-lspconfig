---@brief
---
--- https://ast-grep.github.io/
---
--- ast-grep(sg) is a fast and polyglot tool for code structural search, lint, rewriting at large scale.
--- ast-grep LSP only works in projects that have `sgconfig.y[a]ml` in their root directories.
--- ```sh
--- npm install [-g] @ast-grep/cli
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'ast-grep', 'lsp' },
  workspace_required = true,
  reuse_client = function(client, config)
    config.cmd_cwd = config.root_dir
    return client.config.cmd_cwd == config.cmd_cwd
  end,
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
  root_markers = { 'sgconfig.yaml', 'sgconfig.yml' },
}
