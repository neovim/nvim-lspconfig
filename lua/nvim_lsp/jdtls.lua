local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local server_name = "jdtls"
skeleton[server_name] = {
  default_config = {
    cmd = {"jdtls"};
    filetypes = {"java"};
    root_dir = util.root_pattern('.project', 'pom.xml', 'project.xml', 'build.gradle', '.git');
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  -- on_attach = function(client, bufnr) end;
  on_new_config = function(new_config)
    new_config.cmd[2] = '-data';
    new_config.cmd[3] = new_config.root_dir('.');
  end;
  docs = {
    description = [[
For language server related questions visit:
https://github.com/eclipse/eclipse.jdt.ls
]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

-- vim:et ts=2 sw=2
