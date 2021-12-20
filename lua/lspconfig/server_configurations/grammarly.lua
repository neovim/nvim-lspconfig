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

WARNING: Since this language server uses Grammarly's API, any document you open with it running is shared with them. Please evaluate their [privacy policy](https://www.grammarly.com/privacy-policy) before using this.
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
