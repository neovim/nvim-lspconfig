local util = require 'lspconfig.util'

local workspace_markers = { 'package.json', 'jsconfig.json', '.git' }

return {
  default_config = {
    cmd = { 'quick-lint-js', '--lsp-server' },
    filetypes = { 'javascript' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://quick-lint-js.com/

quick-lint-js finds bugs in JavaScript programs.

See installation [instructions](https://quick-lint-js.com/install/)
]],
  },
}
