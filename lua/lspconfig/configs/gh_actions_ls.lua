local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'gh-actions-language-server', '--stdio' },
    filetypes = { 'yaml' },
    root_dir = function(filename)
      if not filename:find('/%.github/workflows/.+%.ya?ml') then
        return
      end
      return util.root_pattern('.github')
    end,
    single_file_support = false,
    capabilities = {
      workspace = {
        didChangeWorkspaceFolders = {
          dynamicRegistration = true,
        },
      },
    },
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
