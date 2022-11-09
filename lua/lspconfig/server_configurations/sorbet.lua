local util = require 'lspconfig.util'

local workspace_markers = { 'Gemfile', '.git' }

return {
  default_config = {
    cmd = { 'srb', 'tc', '--lsp' },
    filetypes = { 'ruby' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://sorbet.org

Sorbet is a fast, powerful type checker designed for Ruby.

You can install Sorbet via gem install. You might also be interested in how to set
Sorbet up for new projects: https://sorbet.org/docs/adopting.

```sh
gem install sorbet
```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
