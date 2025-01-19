return {
  default_config = {
    cmd = { 'ghcide', '--lsp' },
    filetypes = { 'haskell', 'lhaskell' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find(
          { 'stack.yaml', 'hie-bios', 'BUILD.bazel', 'cabal.config', 'package.yaml' },
          { path = fname, upward = true }
        )[1]
      )
    end,
  },

  docs = {
    description = [[
https://github.com/digital-asset/ghcide

A library for building Haskell IDE tooling.
"ghcide" isn't for end users now. Use "haskell-language-server" instead of "ghcide".
]],
  },
}
