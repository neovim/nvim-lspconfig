return {
  default_config = {
    cmd = { 'nixd' },
    filetypes = { 'nix' },
    single_file_support = true,
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'flake.nix', '.git' }, { path = fname, upward = true })[1])
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
