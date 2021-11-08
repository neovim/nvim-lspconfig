local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'dotls'
local bin_name = 'dot-language-server'

local root_files = {
  '.git',
}

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'dot' },
    root_dir = util.root_pattern(unpack(root_files)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/nikeee/dot-language-server

`dot-language-server` can be installed via `npm`:
```sh
npm install -g dot-language-server
```
    ]],
  },
}
