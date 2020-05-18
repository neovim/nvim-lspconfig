local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.ccls = {
  default_config = {
    cmd = {"ccls"};
    filetypes = {"c", "cpp", "objc", "objcpp"};
    root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git");
  };
  docs = {
    vscode = "ccls-project.ccls";
    description = [[
https://github.com/MaskRay/ccls/wiki

ccls relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a compile_flags.txt.
]];
    default_config = {
      root_dir = [[root_pattern("compile_commands.json", "compile_flags.txt", ".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
