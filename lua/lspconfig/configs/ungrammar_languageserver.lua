local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ungrammar-languageserver', '--stdio' },
    filetypes = { 'ungrammar' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    settings = {
      ungrammar = {
        validate = {
          enable = true,
        },
        format = {
          enable = true,
        },
      },
    },
  },
  docs = {
    description = [[
https://github.com/binhtran432k/ungrammar-language-features
Language Server for Ungrammar.

Ungrammar Language Server can be installed via npm:
```sh
npm i ungrammar-languageserver -g
```
    ]],
  },
}
