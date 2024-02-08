local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'harper-ls', '--stdio' },
    filetypes = {
      'markdown',
      'rust',
      'typescript',
      'typescriptreact',
      'javascript',
      'python',
      'go',
      'c',
      'cpp',
      'ruby',
      'swift',
      'csharp',
      'toml',
      'lua',
    },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/chilipepperhott/harper_ls

The language server for Harper, the slim, clean language checker for developers.
As of right now, there are no settings to be configured for `harper_ls`.
    ]],
    default_config = {
      root_dir = [[bufdir]],
    },
  },
}
