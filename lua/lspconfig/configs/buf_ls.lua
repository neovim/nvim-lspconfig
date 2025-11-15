-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
return {
  default_config = {
    cmd = { 'buf', 'beta', 'lsp', '--timeout=0', '--log-format=text' },
    filetypes = { 'proto' },
    root_dir = require('lspconfig.util').root_pattern('buf.yaml', '.git'),
  },
  docs = {
    description = [[
https://github.com/bufbuild/buf

buf beta lsp included in the cli itself

buf beta lsp is a Protobuf language server compatible with Buf modules and workspaces
]],
  },
}
