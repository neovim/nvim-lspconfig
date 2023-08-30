local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'biome', 'lsp-proxy' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'json',
      'jsonc',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
    },
    root_dir = function(fname)
      return util.find_package_json_ancestor(fname)
        or util.find_node_modules_ancestor(fname)
        or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://biomejs.dev

Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).

```sh
npm install [-g] @biomejs/biome
```
]],
    default_config = {
      root_dir = [[root_pattern('package.json', 'node_modules', '.git', 'biome.json')]],
    },
  },
}
