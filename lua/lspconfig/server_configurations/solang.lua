local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'solang', '--language-server', '--target', 'ewasm' },
    filetypes = { 'solidity' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
A language server for Solidity

See the [documentation](https://solang.readthedocs.io/en/latest/installing.html) for installation instructions.

The language server only provides the following capabilities:
* Syntax highlighting
* Diagnostics
* Hover

There is currently no support for completion, goto definition, references, or other functionality.

]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
