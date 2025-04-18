---@brief
---
--- https://koka-lang.github.io/koka/doc/index.html
--- Koka is a functional programming language with effect types and handlers.
return {
  cmd = { 'koka', '--language-server', '--lsstdio' },
  filetypes = { 'koka' },
  root_markers = { '.git' },
}
