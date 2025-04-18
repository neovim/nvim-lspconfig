---@brief
---
--- https://solargraph.org/
---
--- solargraph, a language server for Ruby
---
--- You can install solargraph via gem install.
---
--- ```sh
--- gem install --user-install solargraph
--- ```
return {
  cmd = { 'solargraph', 'stdio' },
  settings = {
    solargraph = {
      diagnostics = true,
    },
  },
  init_options = { formatting = true },
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.git' },
}
