local util = require 'lspconfig.util'

local bin_name = 'cucumber-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'cucumber' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://cucumber.io
https://github.com/cucumber/common
https://www.npmjs.com/package/@cucumber/language-server

Language server for Cucumber.

`cucumber-language-server` can be installed via `npm`:
```sh
npm install -g @cucumber/language-server
```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
