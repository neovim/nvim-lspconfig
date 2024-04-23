local util = require 'lspconfig.util'

return {
  default_config = {
    root_dir = function(fname, _)
      return require("lspconfig").util.root_pattern('.git', '.obsidian', '.moxide.toml')(fname) or vim.uv.cwd()
    end,
    filetypes = { 'markdown' },
    cmd = { 'markdown-oxide' },
  },
  docs = {
    description = [[
https://github.com/Feel-ix-343/markdown-oxide

Markdown language server with advanced linking support made to be completely compatible with Obsidian; An Obsidian Language Server

Check the readme to see how to get nvim-cmp properly working.
    ]],
  },
}
