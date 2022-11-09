local util = require 'lspconfig.util'

local bin_name = 'solargraph'
local cmd = { bin_name, 'stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'stdio' }
end

local workspace_markers = { 'Gemfile', '.git' }

return {
  default_config = {
    cmd = cmd,
    settings = {
      solargraph = {
        diagnostics = true,
      },
    },
    init_options = { formatting = true },
    filetypes = { 'ruby' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://solargraph.org/

solargraph, a language server for Ruby

You can install solargraph via gem install.

```sh
gem install --user-install solargraph
```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
