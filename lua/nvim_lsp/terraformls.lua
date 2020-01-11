local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

skeleton.terraformls = {
  default_config = {
    cmd = {"terraform-lsp"};
    filetypes = {"terraform"};
    root_dir = util.root_pattern(".git");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  docs = {
    vscode = "mauve.terraform";
    description = [[
https://github.com/juliosueiras/terraform-lsp

Terraform language server
You can use [released binary](https://github.com/juliosueiras/terraform-lsp/releases) or [build](https://github.com/juliosueiras/terraform-lsp#building) your own.
]];
    default_config = {
      root_dir = [[root_pattern(".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
