local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'css-variables-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    root_dir = util.root_pattern('package.json', '.git'),
  },
  docs = {
    description = [[
https://github.com/vunguyentuan/vscode-css-variables/tree/master/packages/css-variables-language-server

CSS variables autocompletion and go-to-definition

`css-variables-language-server` can be installed via `npm`:

```sh
npm i -g css-variables-language-server
```

```
]],
    default_config = {
      root_dir = [[root_pattern("package.json", ".git") or bufdir]],
    },
  },
}
