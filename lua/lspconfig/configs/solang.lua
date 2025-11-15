-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
return {
  default_config = {
    cmd = { 'solang', 'language-server', '--target', 'evm' },
    filetypes = { 'solidity' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
A language server for Solidity

See the [documentation](https://solang.readthedocs.io/en/latest/installing.html) for installation instructions.

The language server only provides the following capabilities:
* Syntax highlighting
* Diagnostics
* Hover

There is currently no support for completion, goto definition, references, or other functionality.

]],
  },
}
