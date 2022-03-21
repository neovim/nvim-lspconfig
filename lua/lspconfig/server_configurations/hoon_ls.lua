local util = require 'lspconfig.util'

local bin_name = 'hoon-language-server'
local cmd = { bin_name, '-p', '8080' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '-p', '8080' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'hoon' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/urbit/hoon-language-server

A language server for Hoon.

The language server can be installed via `npm install -g hoon-language-server`

Install and build Urbit. Then, start a fake ~zod with `urbit -lF zod -c zod`.
And start the language server at the Urbit Dojo prompt with: `|start %language-server`

If your ship does not run on port 8080 change the `cmd` setting:

```lua
require'lspconfig'.elixirls.setup{
    cmd = { 'hoon-language-server', '-p', '80' }
}
```
]],
  },
}
