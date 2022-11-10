local util = require 'lspconfig.util'

local workspace_markers = { '.git' }
return {
  default_config = {
    cmd = { 'rnix-lsp' },
    filetypes = { 'nix' },
    root_dir = function(fname)
      -- FIXME(kylo252): why does this use homedir?
      return util.root_pattern(unpack(workspace_markers))(fname) or vim.loop.os_homedir()
    end,
    settings = {},
    init_options = {},
  },
  docs = {
    description = [[
https://github.com/nix-community/rnix-lsp

A language server for Nix providing basic completion and formatting via nixpkgs-fmt.

To install manually, run `cargo install rnix-lsp`. If you are using nix, rnix-lsp is in nixpkgs.

This server accepts configuration via the `settings` key.

    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
