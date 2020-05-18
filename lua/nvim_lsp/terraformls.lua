local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.terraformls = {
  default_config = {
    cmd = {"terraform-lsp"};
    filetypes = {"terraform"};
    root_dir = util.root_pattern(".terraform", ".git");
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/hashicorp/vscode-terraform/master/package.json";
    description = [[
https://github.com/juliosueiras/terraform-lsp

Terraform language server
You can use [released binary](https://github.com/juliosueiras/terraform-lsp/releases) or [build](https://github.com/juliosueiras/terraform-lsp#building) your own.
]];
    default_config = {
      root_dir = [[root_pattern(".terraform", ".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
