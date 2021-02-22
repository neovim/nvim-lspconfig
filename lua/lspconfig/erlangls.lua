local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'


configs.erlangls = {
  default_config = {
    cmd = { "erlang_ls" };
    filetypes = { "erlang" };
    root_dir = function(fname)
      return util.root_pattern("rebar.config", "erlang.mk", ".git")(fname) or util.path.dirname(fname)
    end;
  };
  docs = {
    description = [[
https://erlang-ls.github.io

Language Server for Erlang.
]];
    default_config = {
      root_dir = [[root_pattern('rebar.config', 'erlang.mk', '.git') or util.path.dirname(fname)]]
    }
  };
}
