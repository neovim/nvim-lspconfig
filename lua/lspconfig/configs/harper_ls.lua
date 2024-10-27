local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'harper-ls', '--stdio' },
    filetypes = {
      'c',
      'cpp',
      'cs',
      'gitcommit',
      'go',
      'html',
      'java',
      'javascript',
      'lua',
      'markdown',
      'python',
      'ruby',
      'rust',
      'swift',
      'toml',
      'typescript',
      'typescriptreact',
    },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/chilipepperhott/harper

The language server for Harper, the slim, clean language checker for developers.

See [docs](https://github.com/chilipepperhott/harper/tree/master/harper-ls#configuration) for more information on settings.

In short, however, they should look something like this:
```lua
lspconfig.harper_ls.setup {
  settings = {
    ["harper-ls"] = {
      userDictPath = "~/dict.txt"
    }
  },
}
```
    ]],
  },
}
