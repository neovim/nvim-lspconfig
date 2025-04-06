local util = require 'lspconfig.util'

local function switch_source_header(bufnr)
  local method_name = 'textDocument/switchSourceHeader'
  bufnr = util.validate_bufnr(bufnr)
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'ccls' })[1]
  if not client then
    return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  client.request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify('corresponding file cannot be determined')
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

return {
  default_config = {
    cmd = { 'ccls' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_dir = function(fname)
      return util.root_pattern('compile_commands.json', '.ccls')(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    offset_encoding = 'utf-32',
    -- ccls does not support sending a null root directory
    single_file_support = false,
  },
  commands = {
    CclsSwitchSourceHeader = {
      function()
        switch_source_header(0)
      end,
      description = 'Switch between source/header',
    },
  },
  docs = {
    description = [[
https://github.com/MaskRay/ccls/wiki

ccls relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a .ccls.
For details on how to automatically generate one using CMake look [here](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html). Alternatively, you can use [Bear](https://github.com/rizsotto/Bear).

Customization options are passed to ccls at initialization time via init_options, a list of available options can be found [here](https://github.com/MaskRay/ccls/wiki/Customization#initialization-options). For example:

```lua
local lspconfig = require'lspconfig'
lspconfig.ccls.setup {
  init_options = {
    compilationDatabaseDirectory = "build";
    index = {
      threads = 0;
    };
    clang = {
      excludeArgs = { "-frounding-math"} ;
    };
  }
}

```

]],
  },
}
