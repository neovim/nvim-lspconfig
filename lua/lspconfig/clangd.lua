local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, _, result)
    if err then error(tostring(err)) end
    if not result then print ("Corresponding file can’t be determined") return end
    vim.api.nvim_command('edit '..vim.uri_to_fname(result))
  end)
end

-- https://clangd.llvm.org/extensions.html#file-status
local function file_status_update(_, _, message, client_id)
  local client = vim.lsp.get_client_by_id(client_id)
  if not client then
    vim.api.nvim_err_writeln("LSP[id=" .. client_id .. "] client has shut down after sending the message")
    vim.api.nvim_command("redraw")
  end
  client.messages.status = { uri = message.uri, content = message.state }
  vim.api.nvim_command('doautocmd <nomodeline> User LspStatusUpdate')
end

local root_pattern = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")

local default_capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
  textDocument = {
    completion = {
      editsNearCursor = true
    }
  },
  offsetEncoding = {"utf-8", "utf-16"}
})

configs.clangd = {
  default_config = {
    cmd = {"clangd", "--background-index"};
    filetypes = {"c", "cpp", "objc", "objcpp"};
    root_dir = function(fname)
      local filename = util.path.is_absolute(fname) and fname
        or util.path.join(vim.loop.cwd(), fname)
      return root_pattern(filename) or util.path.dirname(filename)
    end;
    on_init = function(client, result)
      if result.offsetEncoding then
        client.offset_encoding = result.offsetEncoding
      end
    end;
    capabilities = default_capabilities;
    handlers = {
        ['textDocument/clangd.fileStatus'] = file_status_update
    };
    init_options = {
      clangdFileStatus = true;
    };
  };
  commands = {
    ClangdSwitchSourceHeader = {
      function()
        switch_source_header(0)
      end;
      description = "Switch between source/header";
    };
  };
  docs = {
    description = [[
https://clang.llvm.org/extra/clangd/Installation.html

**NOTE:** Clang >= 9 is recommended! See [this issue for more](https://github.com/neovim/nvim-lsp/issues/23).

clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a compile_flags.txt.
For details on how to automatically generate one using CMake look [here](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html).
]];
    default_config = {
      cmd = [[{ "clangd", "--background-index" }]];
      file_types = [[{ "c", "cpp", "obj", "objcpp" }]];
      root_dir = [[root_pattern("compile_commands.json", "compile_flags.txt", ".git") or dirname]];
      on_init = [[function to handle changing offsetEncoding]];
      capabilities = [[default capabilities, with offsetEncoding utf-8]];
      handlers = [[handler for textDocument/clangd.fileStatus extension]];
      init_options = [[{ clangdFileStatus = true }]];
    };
  };
}

configs.clangd.switch_source_header = switch_source_header
-- vim:et ts=2 sw=2
