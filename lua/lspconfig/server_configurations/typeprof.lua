local util = require 'lspconfig.util'

local workspace_markers = { 'Gemfile', '.git' }

return {
  default_config = {
    cmd = { 'typeprof', '--lsp', '--stdio' },
    filetypes = { 'ruby', 'eruby' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/ruby/typeprof

`typeprof` is the built-in analysis and LSP tool for Ruby 3.1+.
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
