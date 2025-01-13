local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ruby-lsp' },
    filetypes = { 'ruby', 'eruby' },
    root_dir = util.root_pattern('Gemfile', '.git'),
    init_options = {
      formatter = 'auto',
    },
    single_file_support = true,
  },
  docs = {
    description = [[
https://shopify.github.io/ruby-lsp/

This gem is an implementation of the language server protocol specification for
Ruby, used to improve editor features.

Install the gem. There's no need to require it, since the server is used as a
standalone executable.

```sh
gem install ruby-lsp
```
    ]],
  },
}
