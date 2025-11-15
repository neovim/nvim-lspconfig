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
    cmd = { 'erg', '--language-server' },
    filetypes = { 'erg' },
    root_dir = function(fname)
      return util.root_pattern 'package.er'(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/erg-lang/erg#flags ELS

ELS (erg-language-server) is a language server for the Erg programming language.

erg-language-server can be installed via `cargo` and used as follows:
 ```sh
 cargo install erg --features els
 erg --language-server
 ```
    ]],
  },
}
