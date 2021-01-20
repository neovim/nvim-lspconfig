local log = require('vim/lsp/log')
local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "bashls"

configs[server_name] = {
  default_config = {
    cmd = {"bash-language-server", "start"};
    filetypes = {"sh"};
    root_dir = function(fname)
      local dirname = util.path.dirname(fname)

      -- Prevent the bash-language-server from scanning the entire home folder.
      if dirname == vim.loop.os_homedir() then
        log.info('Not setting root_dir to prevent scanning everything in $HOME')
        return nil
      end

      return dirname
    end
  };
  docs = {
    description = [[
https://github.com/mads-hartmann/bash-language-server

Language server for bash, written using tree sitter in typescript.
]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

-- vim:et ts=2 sw=2
