local util = require 'lspconfig.util'

local function migrate_to_svelte_5()
  local clients = vim.lsp.get_clients({
    bufnr = 0,
    name = 'svelte',
  })
  for _, client in ipairs(clients) do
    client:exec_cmd({
      command = 'migrate_to_svelte_5',
      arguments = { vim.uri_from_bufnr(0) },
    })
  end
end

return {
  default_config = {
    cmd = { 'svelteserver', '--stdio' },
    filetypes = { 'svelte' },
    root_dir = util.root_pattern('package.json', '.git'),
  },
  commands = {
    MigrateToSvelte5 = {
      migrate_to_svelte_5,
      description = 'Migrate Component to Svelte 5 Syntax',
    },
  },
  docs = {
    description = [[
https://github.com/sveltejs/language-tools/tree/master/packages/language-server

Note: assuming that [ts_ls](#ts_ls) is setup, full JavaScript/TypeScript support (find references, rename, etc of symbols in Svelte files when working in JS/TS files) requires per-project installation and configuration of [typescript-svelte-plugin](https://github.com/sveltejs/language-tools/tree/master/packages/typescript-plugin#usage).

`svelte-language-server` can be installed via `npm`:
```sh
npm install -g svelte-language-server
```
]],
  },
}
