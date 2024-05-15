local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'bitbake-language-server' },
    filetypes = { 'bitbake' },
    root_dir = util.root_pattern '.git',
  },
  docs = {
    description = [[
🛠️ bitbake language server
]],
  },
}
