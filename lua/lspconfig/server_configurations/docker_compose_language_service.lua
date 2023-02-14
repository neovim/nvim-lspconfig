local util = require 'lspconfig.util'

local bin_name = 'docker-compose-langserver'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'yaml' },
    root_dir = util.root_pattern 'docker-compose.yaml',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/microsoft/compose-language-service
This project contains a language service for Docker Compose.

`compose-language-service` can be installed via `npm`:

```sh
npm install @microsoft/compose-language-service
```
]],
    default_config = {
      root_dir = [[root_pattern("docker-compose.yaml")]],
    },
  },
}
