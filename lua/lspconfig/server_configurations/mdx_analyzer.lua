local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'mdx-language-server', '--stdio' },
    filetypes = { 'markdown.mdx' },
    root_dir = util.root_pattern 'package.json',
    single_file_support = true,
    settings = {},
  },
  commands = {},
  docs = {
    description = [[
https://github.com/mdx-js/mdx-analyzer

`mdx-analyzer`, a language server for MDX
]],
  },
}
