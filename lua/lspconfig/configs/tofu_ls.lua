local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'tofu-ls', 'serve' },
    filetypes = { 'terraform', 'terraform-vars' },
    root_dir = util.root_pattern('.terraform', '.git'),
  },
  docs = {
    description = [[
https://github.com/opentofu/tofu-ls

OpenTofu language server
Download a released binary from https://github.com/opentofu/tofu-ls/releases.
]],
  },
}
