local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'rome', 'lsp-proxy' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'json',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
    },
    root_dir = function(fname)
      return util.find_package_json_ancestor(fname)
        or vim.fs.find('node_modules', { path = fname, upward = true })[1]
        or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://rome.tools

Language server for the Rome Frontend Toolchain.

(Unmaintained, use [Biome](https://biomejs.dev/blog/annoucing-biome) instead.)

```sh
npm install [-g] rome
```
]],
  },
}
