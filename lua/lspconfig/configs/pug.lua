-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
return {
  default_config = {
    cmd = { 'pug-lsp' },
    filetypes = { 'pug' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('package.json', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/opa-oz/pug-lsp

An implementation of the Language Protocol Server for [Pug.js](http://pugjs.org)

PugLSP can be installed via `go install github.com/opa-oz/pug-lsp@latest`, or manually downloaded from [releases page](https://github.com/opa-oz/pug-lsp/releases)
    ]],
  },
}
