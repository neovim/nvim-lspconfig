local util = require 'lspconfig.util'

local workspace_markers = { 'Package.swift', '.git' }

return {
  default_config = {
    cmd = { 'sourcekit-lsp' },
    filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objective-cpp' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/apple/sourcekit-lsp

Language server for Swift and C/C++/Objective-C.
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
