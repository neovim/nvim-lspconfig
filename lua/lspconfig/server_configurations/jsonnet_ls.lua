local util = require 'lspconfig.util'

-- common jsonnet library paths
local function jsonnet_path(root_dir)
  local paths = {
    util.path.join(root_dir, 'lib'),
    util.path.join(root_dir, 'vendor'),
  }
  return table.concat(paths, ':')
end

local workspace_markers = { 'jsonnetfile.json', '.git' }

return {
  default_config = {
    cmd = { 'jsonnet-language-server' },
    filetypes = { 'jsonnet', 'libsonnet' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    on_new_config = function(new_config, root_dir)
      if not new_config.cmd_env then
        new_config.cmd_env = {}
      end
      if not new_config.cmd_env.JSONNET_PATH then
        new_config.cmd_env.JSONNET_PATH = jsonnet_path(root_dir)
      end
    end,
  },
  docs = {
    description = [[
https://github.com/grafana/jsonnet-language-server

A Language Server Protocol (LSP) server for Jsonnet.

The language server can be installed with `go`:
```sh
go install github.com/grafana/jsonnet-language-server@latest
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
