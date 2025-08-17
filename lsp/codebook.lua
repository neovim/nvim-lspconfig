---@brief
---
--- https://github.com/blopker/codebook
---
---  An unholy spell checker for code.
---
--- `codebook-lsp` can be installed by following the instructions [here](https://github.com/blopker/codebook/blob/main/README.md#installation).
---
--- The default `cmd` assumes that the `codebook-lsp` binary can be found in `$PATH`.
---
return {
  cmd = { 'codebook-lsp', 'serve' },
  filetypes = {
    'c',
    'css',
    'gitcommit',
    'go',
    'haskell',
    'html',
    'java',
    'javascript',
    'javascriptreact',
    'lua',
    'markdown',
    'php',
    'python',
    'ruby',
    'rust',
    'toml',
    'text',
    'typescript',
    'typescriptreact',
  },
  root_markers = { '.git', 'codebook.toml', '.codebook.toml' },
}
