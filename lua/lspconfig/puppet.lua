local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "puppet"
local bin_name = "puppet-languageserver"

local root_files = {
  'manifests',
  '.puppet-lint.rc',
  'hiera.yaml',
  '.git',
}

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"puppet"};
    root_dir = function(filename)
      return util.root_pattern(unpack(root_files))(filename) or
             util.path.dirname(filename)
    end
  };
  docs = {
    description = [[
https://github.com/puppetlabs/puppet-editor-services

LSP server for Puppet.
]];
    default_config = {
      root_dir = [[root_pattern("manifests", ".puppet-lint.rc", "hiera.yaml", ".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
