local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'gh-actions-language-server', '--stdio' },
    filetypes = { 'yaml.github' },
    root_dir = util.root_pattern('.github', '.git'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/lttb/gh-actions-language-server

Language server for GitHub Actions.

`gh-actions-language-server` can be installed via `npm`:

```sh
npm install -g gh-actions-language-server
```
]],
  },
}
