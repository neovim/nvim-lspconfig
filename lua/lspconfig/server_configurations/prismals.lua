local util = require 'lspconfig.util'

local bin_name = 'prisma-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local workspace_markers = { '.git', 'package.json' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'prisma' },
    workspace_markers = workspace_markers,
    settings = {
      prisma = {
        prismaFmtBinPath = '',
      },
    },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
Language Server for the Prisma JavaScript and TypeScript ORM

`@prisma/language-server` can be installed via npm
```sh
npm install -g @prisma/language-server
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
