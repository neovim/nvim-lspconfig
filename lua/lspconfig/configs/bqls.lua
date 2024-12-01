return {
  default_config = {
    cmd = { 'bqls' },
    filetypes = { 'sql' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/kitagry/bqls

The `bqls` BigQuery language server can be installed by running:

```sh
$ go install github.com/kitagry/bqls@latest
```
    ]],
  },
}
