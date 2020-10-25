local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.racket = {
  default_config = {
    cmd = {"racket", "-l", "racket-langserver"};
    filetypes = {"racket"};
    root_dir = util.path.dirname;
  };
  docs = {
    description = [[
https://github.com/jeapostrophe/racket-langserver
Racket LSP Implementation

May also require https://github.com/wlangstroth/vim-racket
]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

-- vim:et ts=2 sw=2
