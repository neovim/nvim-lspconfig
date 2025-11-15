-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'elp', 'server' },
    filetypes = { 'erlang' },
    root_dir = util.root_pattern('rebar.config', 'erlang.mk', '.git'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://whatsapp.github.io/erlang-language-platform

ELP integrates Erlang into modern IDEs via the language server protocol and was
inspired by rust-analyzer.
]],
  },
}
