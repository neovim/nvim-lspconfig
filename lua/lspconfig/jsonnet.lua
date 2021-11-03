local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.jsonnet = {
  default_config = {
    cmd = { 'jsonnet-language-server' },
    filetypes = { 'jsonnet', 'libsonnet' },
    root_dir = function(fname)
      return util.root_pattern 'go.work'(fname) or util.root_pattern('go.mod', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/jdbaldry/jsonnet-language-server

A Language Server Protocol (LSP) server for Jsonnet.
]],
    default_config = {
      root_dir = [[root_pattern("go.mod", ".git")]],
    },
  },
}
