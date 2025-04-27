---@brief
--- https://github.com/mdx-js/mdx-analyzer
---
--- `mdx-analyzer`, a language server for MDX

local util = require 'lspconfig.util'

return {
  cmd = { 'mdx-language-server', '--stdio' },
  filetypes = { 'mdx' },
  root_markers = { 'package.json' },
  settings = {},
  init_options = {
    typescript = {},
  },
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and not config.init_options.typescript.tsdk then
      config.init_options.typescript.tsdk = util.get_typescript_server_path(config.root_dir)
    end
  end,
}
