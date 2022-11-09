local util = require 'lspconfig.util'

local bin_name = 'nxls'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local workspace_markers = { 'nx.json', '.git' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'json', 'jsonc' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/nrwl/nx-console/tree/master/apps/nxls

nxls, a language server for Nx Workspaces

`nxls` can be installed via `npm`:
```sh
npm i -g nxls
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
