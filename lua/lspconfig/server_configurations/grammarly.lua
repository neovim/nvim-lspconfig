local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'markdown' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
Grammarly in an LSP, using the Grammarly API.

Requires some manual installation:

1. Clone the Grammarly repo, the upstream is [here](https://github.com/znck/grammarly), it's designed to work with a custom client though, so it requires some modifications. I'd recommend using [this branch of my fork](https://github.com/mtoohey31/grammarly/tree/generic-client-compat) might work for you.
2. Build the server:

```bash
pnpm install && pnpm run build:packages && pnpm run build:server
```

(you can install pnpm with `npm install -g pnpm`)

3. Configure the server, by adding the path to the server's `index.js`, you'll need to modify this to point to where you cloned the Grammarly repo.

```lua
cmd = { "node", ".../grammarly/extension/dist/server/index.js", "--stdio" }
```
]],
    default_config = {
      root_dir = [[current directory]],
    },
  },
}
