local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'oxc_language_server' },
    filetypes = {
      'astro',
      'javascript',
      'javascriptreact',
      'svelte',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
      'vue',
    },
    root_dir = util.root_pattern('.oxlintrc.json'),
    single_file_support = false,

    commands = {
      OxcFixAll = {
        function()
          local client = vim.lsp.get_clients({ bufnr = 0, name = 'oxlint' })[1]
          if client == nil then
            return
          end

          client.request('workspace/executeCommand', {
            command = 'oxc.fixAll',
            arguments = {
              {
                uri = vim.uri_from_bufnr(0),
              },
            },
          }, nil, 0)
        end,
        description = 'Apply fixes to current buffer using oxlint (--fix)',
      },
    },
  },
  docs = {
    description = [[
https://oxc.rs

A collection of JavaScript tools written in Rust.

```sh
npm install [-g] oxlint
```
]],
  },
}
