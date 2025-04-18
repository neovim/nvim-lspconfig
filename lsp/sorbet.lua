---@brief
---
--- https://sorbet.org
---
--- Sorbet is a fast, powerful type checker designed for Ruby.
---
--- You can install Sorbet via gem install. You might also be interested in how to set
--- Sorbet up for new projects: https://sorbet.org/docs/adopting.
---
--- ```sh
--- gem install sorbet
--- ```
return {
  cmd = { 'srb', 'tc', '--lsp' },
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.git' },
}
