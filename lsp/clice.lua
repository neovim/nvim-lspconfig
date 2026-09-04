---@brief
---
--- https://github.com/clice-io/clice
--- Clice is a next-generation language server for modern C++, focused on performance and code intelligence

---@type vim.lsp.Config
return {
  cmd = { 'clice', 'serve' },
  filetypes = { 'c', 'cpp' },
  root_markers = {
    'clice.toml',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac',
    '.git',
  },
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8' },
  },
}
