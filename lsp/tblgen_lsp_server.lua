---@brief
---
--- https://mlir.llvm.org/docs/Tools/MLIRLSP/#tablegen-lsp-language-server--tblgen-lsp-server
---
--- The Language Server for the LLVM TableGen language
---
--- `tblgen-lsp-server` can be installed at the llvm-project repository (https://github.com/llvm/llvm-project)

local function get_command()
  local cmd = { 'tblgen-lsp-server' }
  local files = vim.fs.find('tablegen_compile_commands.yml', { path = vim.fn.expand('%:p:h'), upward = true })
  if #files > 0 then
    local file = files[1]
    table.insert(cmd, '--tablegen-compilation-database=' .. vim.fs.dirname(file) .. '/tablegen_compile_commands.yml')
  end

  return cmd
end

return {
  cmd = get_command(),
  filetypes = { 'tablegen' },
  root_markers = { 'tablegen_compile_commands.yml', '.git' },
}
