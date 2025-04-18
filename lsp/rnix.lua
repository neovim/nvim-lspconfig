---@brief
---
--- https://github.com/nix-community/rnix-lsp
---
--- A language server for Nix providing basic completion and formatting via nixpkgs-fmt.
---
--- To install manually, run `cargo install rnix-lsp`. If you are using nix, rnix-lsp is in nixpkgs.
---
--- This server accepts configuration via the `settings` key.
return {
  cmd = { 'rnix-lsp' },
  filetypes = { 'nix' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, '.git') or vim.uv.os_homedir())
  end,
  settings = {},
  init_options = {},
}
