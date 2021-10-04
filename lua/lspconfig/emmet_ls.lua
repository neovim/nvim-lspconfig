local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'emmet_ls'

configs[server_name] = {
  default_config = {
    cmd = { 'emmet-ls', '--stdio' },
    filetypes = { 'html', 'css' },
    root_dir = function(fname)
      return util.root_pattern '.git'(fname) or vim.fn.getcwd()
    end,
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
      root_dir = "vim's starting directory",
    },
  },
}
