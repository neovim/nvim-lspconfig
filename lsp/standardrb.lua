---@brief
---
--- https://github.com/testdouble/standard
---
--- Ruby Style Guide, with linter & automatic code fixer.
return {
  cmd = { 'standardrb', '--lsp' },
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.git' },
}
