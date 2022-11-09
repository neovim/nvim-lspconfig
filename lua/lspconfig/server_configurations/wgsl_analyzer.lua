local util = require 'lspconfig.util'

local bin_name = 'wgsl_analyzer'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'wgsl' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    settings = {},
  },
  docs = {
    description = [[
https://github.com/wgsl-analyzer/wgsl-analyzer

`wgsl_analyzer` can be installed via `cargo`:
```sh
cargo install --git https://github.com/wgsl-analyzer/wgsl-analyzer wgsl_analyzer
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
