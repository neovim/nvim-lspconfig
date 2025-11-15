-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
return {
  default_config = {
    cmd = { 'starlark', '--lsp' },
    filetypes = { 'star', 'bzl', 'BUILD.bazel' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/facebookexperimental/starlark-rust/
The LSP part of `starlark-rust` is not currently documented,
 but the implementation works well for linting.
This gives valuable warnings for potential issues in the code,
but does not support refactorings.

It can be installed with cargo: https://crates.io/crates/starlark
]],
  },
}
