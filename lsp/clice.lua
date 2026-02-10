---@brief
--- https://github.com/clice-io/clice
---
--- Clice is a next generation C++ language server

---@type vim.lsp.Config
return {
  cmd = { 'clice', '--mode=pipe' },
  filetypes = { 'cpp', },
  root_markers = {
    '.git/',
    'clice.toml',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac', -- AutoTools
  },
}
