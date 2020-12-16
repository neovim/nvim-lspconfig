local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.zls = {
    default_config = {
        cmd = {"zls"};
        filetypes = {"zig"};
        settings = {
            ["zls"] = {}
        },
        root_dir = util.path.dirname;
    },
    docs = {
        description = [[
           https://github.com/zigtools/zls

           `Zig LSP implementation + Zig Language Server`.
        ]];
        default_config = {
            root_dir = "vim's starting directory";
        };
    };
};
