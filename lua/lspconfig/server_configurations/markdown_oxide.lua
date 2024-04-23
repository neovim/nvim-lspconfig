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

Let's record your consciousness! Bring your own text editor!
Implemented as a language server compatible with any text
editor, Markdown-Oxide is attempting to be the best PKM
system for software enthusiasts.

Check the readme to see how to properly setup nvim-cmp.
    ]],
  },
}
