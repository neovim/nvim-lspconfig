---@brief
---
--- https://whatsapp.github.io/erlang-language-platform
---
--- ELP integrates Erlang into modern IDEs via the language server protocol and was
--- inspired by rust-analyzer.
return {
  cmd = { 'elp', 'server' },
  filetypes = { 'erlang' },
  root_markers = { 'rebar.config', 'erlang.mk', '.git' },
}
