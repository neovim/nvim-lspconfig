local util = require 'lspconfig.util'

local bin_name = 'marksman'
local cmd = { bin_name, 'server' }

local workspace_markers = { '.marksman.toml', '.git' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'markdown' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/artempyanykh/marksman

Marksman is a Markdown LSP server providing completion, cross-references, diagnostics, and more.

Marksman works on MacOS, Linux, and Windows and is distributed as a self-contained binary for each OS.

Pre-built binaries can be downloaded from https://github.com/artempyanykh/marksman/releases
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
