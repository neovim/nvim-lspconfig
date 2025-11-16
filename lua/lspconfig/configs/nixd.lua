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
    cmd = { 'nixd' },
    filetypes = { 'nix' },
    single_file_support = true,
    root_dir = function(fname)
      return util.root_pattern 'flake.nix'(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/nix-community/nixd

Nix language server, based on nix libraries.

If you are using Nix with Flakes support, run `nix profile install github:nix-community/nixd` to install.
Check the repository README for more information.
    ]],
  },
}
