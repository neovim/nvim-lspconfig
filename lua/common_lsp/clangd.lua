local skeleton = require 'common_lsp/skeleton'
local util = require 'common_lsp/util'
local lsp = vim.lsp

local default_capabilities = lsp.protocol.make_client_capabilities()
default_capabilities.offsetEncoding = {"utf-8", "utf-16"}

skeleton.clangd = {
  default_config = {
    cmd = {"clangd", "--background-index"};
    filetypes = {"c", "cpp", "objc", "objcpp"};
    root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
    capabilities = default_capabilities;
    on_init = vim.schedule_wrap(function(client, result)
      if result.offsetEncoding then
        client.offset_encoding = result.offsetEncoding
      end
    end)
  };
  -- commands = {};
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://clang.llvm.org/extra/clangd/Installation.html

clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
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

