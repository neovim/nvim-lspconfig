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
    cmd = { 'fish-lsp', 'start' },
    filetypes = { 'fish' },
    root_dir = function(fname)
      return util.root_pattern('config.fish')(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/ndonfris/fish-lsp

A Language Server Protocol (LSP) tailored for the fish shell.
This project aims to enhance the coding experience for fish,
by introducing a suite of intelligent features like auto-completion,
scope aware symbol analysis, per-token hover generation, and many others.

[homepage](https://www.fish-lsp.dev/)
]],
  },
}
