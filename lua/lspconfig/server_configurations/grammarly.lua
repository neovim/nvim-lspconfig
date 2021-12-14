local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'markdown' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/znck/grammarly

A language server which provides access to Grammarly analysis via the API.

Requires some manual installation:

1. Clone the Grammarly repo, the upstream is [here](https://github.com/znck/grammarly), it's designed to work with a custom client though, so it requires some modifications. Using [this fork's `generic-client-compat` branch](https://github.com/mtoohey31/grammarly/tree/generic-client-compat) is recommended.
2. Build the server:

```bash
pnpm install && pnpm run build:packages && pnpm run build:server
```

(pnpm can be installed with `npm install -g pnpm`)

3. Configure the server, by adding the path to the server's `index.js`. The example below will need to be modified to point to the location of the Grammarly repo.

```lua
cmd = { "node", ".../grammarly/extension/dist/server/index.js", "--stdio" }
```
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
