local util = require 'lspconfig.util'

return {
  default_config = {
    init_options = { hostInfo = 'neovim' },
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    root_dir = function(fname)
      return util.root_pattern 'tsconfig.json'(fname)
        or util.root_pattern('package.json', 'jsconfig.json', '.git')(fname)
    end,
    single_file_support = true,
    handlers = {
      ['_typescript.rename'] = function(_, result, ctx)
        if not result then
          return {}
        end

        local client = vim.lsp.get_client_by_id(ctx.client_id)

        if client then
          vim.lsp.util.jump_to_location({
            uri = result.textDocument.uri,
            range = {
              start = result.position,
              ['end'] = result.position,
            },
          }, client.offset_encoding, true)

          vim.lsp.buf.rename(nil, {
            filter = function(c)
              return c == client
            end,
          })
        end

        return {}
      end,
    },
  },
  docs = {
    description = [[
https://github.com/typescript-language-server/typescript-language-server

`typescript-language-server` depends on `typescript`. Both packages can be installed via `npm`:
```sh
npm install -g typescript typescript-language-server
```

To configure typescript language server, add a
[`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html) or
[`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to the root of your
project.

Here's an example that disables type checking in JavaScript files.

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "es6",
    "checkJs": false
  },
  "exclude": [
    "node_modules"
  ]
}
```
]],
    default_config = {
      root_dir = [[root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")]],
    },
  },
}
