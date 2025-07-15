---@brief
---
--- https://github.com/MaskRay/ccls/wiki
---
--- ccls relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
--- as compile_commands.json or, for simpler projects, a .ccls.
--- For details on how to automatically generate one using CMake look [here](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html). Alternatively, you can use [Bear](https://github.com/rizsotto/Bear).
---
--- Customization options are passed to ccls at initialization time via init_options, a list of available options can be found [here](https://github.com/MaskRay/ccls/wiki/Customization#initialization-options). For example:
---
--- ```lua
--- vim.lsp.config("ccls", {
---   init_options = {
---     compilationDatabaseDirectory = "build";
---     index = {
---       threads = 0;
---     };
---     clang = {
---       excludeArgs = { "-frounding-math"} ;
---     };
---   }
--- })
--- ```

local function switch_source_header(client, bufnr)
  local method_name = 'textDocument/switchSourceHeader'
  local params = vim.lsp.util.make_text_document_params(bufnr)
  client:request(method_name, params, function(err, result)
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
  cmd = { 'ccls' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = { 'compile_commands.json', '.ccls', '.git' },
  offset_encoding = 'utf-32',
  -- ccls does not support sending a null root directory
  workspace_required = true,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCclsSwitchSourceHeader', function()
      switch_source_header(client, bufnr)
    end, { desc = 'Switch between source/header' })
  end,
}
