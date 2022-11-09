local util = require 'lspconfig.util'

local bin_name = 'docker-langserver'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local workspace_markers = { 'Dockerfile' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'dockerfile' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/rcjsuen/dockerfile-language-server-nodejs

`docker-langserver` can be installed via `npm`:
```sh
npm install -g dockerfile-language-server-nodejs
```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
