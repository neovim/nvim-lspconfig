local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'unofficial-grammarly-language-server', '--stdio' },
    filetypes = { 'markdown' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    handlers = {
      ['$/updateDocumentState'] = function()
        return ''
      end,
    },
  },
  docs = {
    description = [[
https://github.com/emacs-grammarly/unofficial-grammarly-language-server

`unofficial-grammarly-language-server` can be installed via `npm`:

```sh
npm i -g @emacs-grammarly/unofficial-grammarly-language-server
```
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
