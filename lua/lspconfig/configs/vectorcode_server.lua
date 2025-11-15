-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
return {
  default_config = {
    cmd = { 'vectorcode-server' },
    root_dir = vim.fs.root(0, { '.vectorcode', '.git' }),
    single_file_support = false,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/Davidyz/VectorCode

A Language Server Protocol implementation for VectorCode, a code repository indexing tool.
    ]],
  },
}
