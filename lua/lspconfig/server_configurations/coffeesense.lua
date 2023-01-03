local util = require 'lspconfig.util'

local bin_name = 'coffeesense-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'coffee' },
    root_dir = util.root_pattern 'package.json',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/phil294/coffeesense

CoffeeSense Language Server
`coffeesense-language-server` can be installed via `npm`:
```sh
npm install -g coffeesense-language-server
```
]],
  },
}
