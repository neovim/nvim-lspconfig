local bin_name = 'bsc'
local cmd = { bin_name, '--lsp', '--stdio' }
local util = require 'lspconfig/util'

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

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
