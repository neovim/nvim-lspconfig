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
    cmd = { 'mdx-language-server', '--stdio' },
    filetypes = { 'mdx' },
    root_dir = util.root_pattern 'package.json',
    single_file_support = true,
    settings = {},
    init_options = {
      typescript = {},
    },
    on_new_config = function(new_config, new_root_dir)
      if vim.tbl_get(new_config.init_options, 'typescript') and not new_config.init_options.typescript.tsdk then
        new_config.init_options.typescript.tsdk = util.get_typescript_server_path(new_root_dir)
      end
    end,
  },
  commands = {},
  docs = {
    description = [[
https://github.com/mdx-js/mdx-analyzer

`mdx-analyzer`, a language server for MDX
]],
  },
}
