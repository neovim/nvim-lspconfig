local util = require 'lspconfig.util'

local bin_name = 'antlersls'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local workspace_markers = { 'composer.json' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'html', 'antlers' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://www.npmjs.com/package/antlers-language-server

`antlersls` can be installed via `npm`:
```sh
npm install -g antlers-language-server
```
]],
  },
}
