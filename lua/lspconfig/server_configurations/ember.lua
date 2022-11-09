local util = require 'lspconfig.util'

local bin_name = 'ember-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local workspace_markers = { 'ember-cli-build.js', '.git' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'handlebars', 'typescript', 'javascript' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/lifeart/ember-language-server

`ember-language-server` can be installed via `npm`:

```sh
npm install -g @lifeart/ember-language-server
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
