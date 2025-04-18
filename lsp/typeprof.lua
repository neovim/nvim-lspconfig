---@brief
---
--- https://github.com/ruby/typeprof
---
--- `typeprof` is the built-in analysis and LSP tool for Ruby 3.1+.
return {
  cmd = { 'typeprof', '--lsp', '--stdio' },
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
}
