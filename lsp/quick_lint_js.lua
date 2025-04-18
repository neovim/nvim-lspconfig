---@brief
---
--- https://quick-lint-js.com/
---
--- quick-lint-js finds bugs in JavaScript programs.
---
--- See installation [instructions](https://quick-lint-js.com/install/)
return {
  cmd = { 'quick-lint-js', '--lsp-server' },
  filetypes = { 'javascript', 'typescript' },
  root_markers = { 'package.json', 'jsconfig.json', '.git' },
}
