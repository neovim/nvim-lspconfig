local util = require 'lspconfig.util'

local workspace_markers = { '.terraform', '.git', '.tflint.hcl' }

return {
  default_config = {
    cmd = { 'tflint', '--langserver' },
    filetypes = { 'terraform' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/terraform-linters/tflint

A pluggable Terraform linter that can act as lsp server.
Installation instructions can be found in https://github.com/terraform-linters/tflint#installation.
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
