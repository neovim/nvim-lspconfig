local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'markdown' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/znck/grammarly

(Note: this upstream repo requires a custom language client, see the instructions for a fork which works with any client.)

A language server which provides access to Grammarly analysis via the API.

Requires some manual installation:

1. Clone [this fork](https://github.com/mtoohey31/grammarly) with `git clone https://github.com/mtoohey31/grammarly`.

See [this heading](https://github.com/mtoohey31/grammarly#differences-between-upstream) for a full list of differences between the upstream repo and the fork.

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
