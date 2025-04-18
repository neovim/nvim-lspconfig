---@brief
---
--- https://github.com/soutaro/steep
---
--- `steep` is a static type checker for Ruby.
---
--- You need `Steepfile` to make it work. Generate it with `steep init`.
return {
  cmd = { 'steep', 'langserver' },
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Steepfile', '.git' },
}
