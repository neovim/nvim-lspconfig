---@brief
---
--- https://github.com/modularml/mojo
---
--- `mojo-lsp-server` can be installed [via Modular](https://developer.modular.com/download)
---
--- Mojo is a new programming language that bridges the gap between research and production by combining Python syntax and ecosystem with systems programming and metaprogramming features.
return {
  cmd = { 'mojo-lsp-server' },
  filetypes = { 'mojo' },
  root_markers = { '.git' },
}
