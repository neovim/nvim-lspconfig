local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.zls = {
    default_config = {
        cmd = {"zls"};
        filetypes = {"zig", "zir"};
        root_dir = function(fname)
            return util.root_pattern("zls.json", ".git")(fname) or util.path.dirname(fname)
        end
    };
    docs = {
        description = [[
           https://github.com/zigtools/zls

           `Zig LSP implementation + Zig Language Server`.
        ]];
        default_config = {
            root_dir = [[util.root_pattern("zls.json", ".git") or current_file_dirname]];
        };
    };
};
