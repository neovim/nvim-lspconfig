local util = require 'lspconfig.util'

return {
  default_config = {
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    filetypes = { 'markdown' },
    cmd = { 'markdown-oxide' },
  },
  docs = {
    description = [[
https://github.com/Feel-ix-343/markdown-oxide

Markdown language server with advanced linking support made to be completely compatible with Obsidian; An Obsidian Language Server

Check the readme to see how to get nvim-cmp properly working.
    ]],
  },
}
