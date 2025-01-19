return {
  default_config = {
    cmd = { 'purescript-language-server', '--stdio' },
    filetypes = { 'purescript' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find(
          { 'bower.json', 'flake.nix', 'psc-package.json', 'shell.nix', 'spago.dhall', 'spago.yaml' },
          { path = fname, upward = true }
        )[1]
      )
    end,
  },
  docs = {
    description = [[
https://github.com/nwolverson/purescript-language-server

The `purescript-language-server` can be added to your project and `$PATH` via

* JavaScript package manager such as npm, pnpm, Yarn, et al.
* Nix under the `nodePackages` and `nodePackages_latest` package sets
]],
  },
}
