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
      return vim.fs.dirname(vim.fs.find('package.json', { path = fname, upward = true })[1])
        or vim.fs.dirname(vim.fs.find('node_modules', { path = fname, upward = true })[1])
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
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
