local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "puppet"
local bin_name = "puppet-languageserver"

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"puppet"};
    root_dir = util.root_pattern("manifests", ".git", ".puppet-lint.rc");
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://github.com/puppetlabs/puppet-editor-services

LSP server for Puppet.
]];
    default_config = {
      root_dir = [[root_pattern("manifests", ".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
