return {
  default_config = {
    cmd = { 'rune-languageserver' },
    filetypes = { 'rune' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://crates.io/crates/rune-languageserver

A language server for the [Rune](https://rune-rs.github.io/) Language,
an embeddable dynamic programming language for Rust
        ]],
  },
}
