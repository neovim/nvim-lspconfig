local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'emmet_ls'

configs[server_name] = {
  default_config = {
    cmd = { 'emmet-ls', '--stdio' },
    filetypes = { 'html', 'css' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/aca/emmet-ls

Package can be installed via `npm`:
```sh
npm install -g emmet-ls
```
]],
    default_config = {
      root_dir = 'git root',
    },
  },
}
