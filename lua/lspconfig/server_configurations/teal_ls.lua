local util = require 'lspconfig.util'

local workspace_markers = { 'tlconfig.lua', '.git' }

return {
  default_config = {
    cmd = {
      'teal-language-server',
      -- use this to enable logging in /tmp/teal-language-server.log
      -- "logging=on",
    },
    filetypes = {
      workspace_markers = workspace_markers,
      'teal',
      -- "lua", -- Also works for lua, but you may get type errors that cannot be resolved within lua itself
    },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/teal-language/teal-language-server

Install with:
```
luarocks install --dev teal-language-server
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
