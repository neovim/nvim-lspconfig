-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'stree', 'lsp' },
    filetypes = { 'ruby' },
    root_dir = util.root_pattern('.streerc', 'Gemfile', '.git'),
  },
  docs = {
    description = [[
https://ruby-syntax-tree.github.io/syntax_tree/

A fast Ruby parser and formatter.

Syntax Tree is a suite of tools built on top of the internal CRuby parser. It
provides the ability to generate a syntax tree from source, as well as the
tools necessary to inspect and manipulate that syntax tree. It can be used to
build formatters, linters, language servers, and more.

```sh
gem install syntax_tree
```
    ]],
  },
}
