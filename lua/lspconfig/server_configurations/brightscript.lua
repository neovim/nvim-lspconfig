local bin_name = 'bsc'
local cmd = { bin_name, '--lsp', '--stdio' }
local util = require "lspconfig/util"

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'brs' },
    single_file_support = true,
    root_dir = util.root_pattern('makefile', 'Makefile', '.git'),
  },
  docs = {
    description = [[
      https://github.com/RokuCommunity/brighterscript
      `brightscript` can be installed via `npm`:
      ```sh
      npm install -g brighterscript
      ```
      ]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
