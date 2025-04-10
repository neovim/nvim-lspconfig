return {
  default_config = {
    cmd = { 'rnix-lsp' },
    filetypes = { 'nix' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]) or vim.uv.os_homedir()
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
  },
}
