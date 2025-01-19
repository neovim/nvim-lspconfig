return {
  default_config = {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'bzl' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.plzconfig' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/thought-machine/please

High-performance extensible build system for reproducible multi-language builds.

The `plz` binary will automatically install the LSP for you on first run
]],
  },
}
