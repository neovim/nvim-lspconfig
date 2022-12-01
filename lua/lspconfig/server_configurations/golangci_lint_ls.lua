local util = require 'lspconfig.util'

local workspace_markers = { 'go.work', 'go.mod', '.golangci.yaml', '.git' }

return {
  default_config = {
    cmd = { 'golangci-lint-langserver' },
    filetypes = { 'go', 'gomod' },
    workspace_markers = workspace_markers,
    init_options = {
      command = { 'golangci-lint', 'run', '--out-format', 'json' },
    },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
Combination of both lint server and client

https://github.com/nametake/golangci-lint-langserver
https://github.com/golangci/golangci-lint


Installation of binaries needed is done via

```
go install github.com/nametake/golangci-lint-langserver@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
