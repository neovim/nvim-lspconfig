local util = require 'lspconfig.util'

local bin_name = 'stree'
local cmd = { bin_name, 'lsp' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'lsp' }
end

local workspace_markers = { '.streerc', 'Gemfile', '.git' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'ruby' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
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
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
