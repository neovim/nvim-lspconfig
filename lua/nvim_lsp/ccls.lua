local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

skeleton.ccls = {
  default_config = util.utf8_config {
    cmd = {"ccls"};
    filetypes = {"c", "cpp", "objc", "objcpp"};
    root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  -- commands = {};
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    vscode = "ccls-project.ccls";
    description = [[
https://github.com/MaskRay/ccls/wiki

ccls relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a compile_flags.txt.
]];
    default_config = {
      root_dir = [[root_pattern("compile_commands.json", "compile_flags.txt", ".git")]];
      on_init = [[function to handle changing offsetEncoding]];
      capabilities = [[default capabilities, with offsetEncoding utf-8]];
    };
  };
}
-- vim:et ts=2 sw=2
