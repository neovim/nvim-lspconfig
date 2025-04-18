---@brief
---
--- https://shopify.github.io/ruby-lsp/
---
--- This gem is an implementation of the language server protocol specification for
--- Ruby, used to improve editor features.
---
--- Install the gem. There's no need to require it, since the server is used as a
--- standalone executable.
---
--- ```sh
--- gem install ruby-lsp
--- ```
return {
  cmd = { 'ruby-lsp' },
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
  init_options = {
    formatter = 'auto',
  },
}
