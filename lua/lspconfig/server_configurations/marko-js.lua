local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'marko-language-server', '--stdio' },
    filetypes = { 'marko' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
      https://github.com/marko-js/language-server

      Using the Language Server Protocol to improve Marko's developer experience.

      Can be installed via npm:
      ```
      npm i -g @marko/language-server
      ```
    ]],
  },
}
