local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

-- common jsonnet library paths
local function jsonnet_path(root_dir)
  local paths = {
    util.path.join(root_dir, 'lib'),
    util.path.join(root_dir, 'vendor'),
  }
  return table.concat(paths, ':')
end

configs.jsonnet_ls = {
  default_config = {
    cmd = { 'jsonnet-language-server' },
    cmd_env = { JSONNET_PATH = vim.fn.getcwd() }, -- will be overwritten by `on_new_config`
    filetypes = { 'jsonnet', 'libsonnet' },
    root_dir = vim.fn.getcwd(), -- will be overwritten by `on_new_config`
    on_new_config = function(new_config, file_dir)
      local root_dir = util.root_pattern('jsonnetfile.json')(file_dir) or util.find_git_ancestor(file_dir)
      new_config.cmd_env = {
        JSONNET_PATH = jsonnet_path(root_dir)
      }
      new_config.root_dir = root_dir
    end
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
