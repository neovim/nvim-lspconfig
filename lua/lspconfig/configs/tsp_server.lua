return {
  default_config = {
    cmd = { 'tsp-server', '--stdio' },
    filetypes = { 'typespec' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'tspconfig.yaml', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/microsoft/typespec

The language server for TypeSpec, a language for defining cloud service APIs and shapes.

`tsp-server` can be installed together with the typespec compiler via `npm`:
```sh
npm install -g @typespec/compiler
```
]],
  },
}
