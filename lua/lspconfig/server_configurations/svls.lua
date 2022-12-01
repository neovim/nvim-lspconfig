local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'svls' },
    filetypes = { 'verilog', 'systemverilog' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/dalance/svls

Language server for verilog and SystemVerilog

`svls` can be installed via `cargo`:
 ```sh
 cargo install svls
 ```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
