return {
  default_config = {
    cmd = { 'regols' },
    filetypes = { 'rego' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '*.rego', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/kitagry/regols

OPA Rego language server.

`regols` can be installed by running:
```sh
go install github.com/kitagry/regols@latest
```
    ]],
  },
}
