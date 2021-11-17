local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

-- common jsonnet library paths
local function jsonnet_path()
  local paths = {
    vim.fn.getcwd() .. '/lib',
    vim.fn.getcwd() .. '/vendor',
  }
  return table.concat(paths, ':')
end

configs.jsonnet_ls = {
  default_config = {
    cmd = { 'jsonnet-language-server' },
    cmd_env = { JSONNET_PATH = jsonnet_path() };
    filetypes = { 'jsonnet', 'libsonnet' },
    root_dir = function(fname)
      return util.root_pattern 'jsonnetfile.json'(fname) or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/jdbaldry/jsonnet-language-server

A Language Server Protocol (LSP) server for Jsonnet.
]],
    default_config = {
      root_dir = [[root_pattern("jsonnetfile.json")]],
    },
  },
}
