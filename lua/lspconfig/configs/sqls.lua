return {
  default_config = {
    cmd = { 'sqls' },
    filetypes = { 'sql', 'mysql' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'config.yml' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/sqls-server/sqls

```lua
require'lspconfig'.sqls.setup{
  cmd = {"path/to/command", "-config", "path/to/config.yml"};
  ...
}
```
Sqls can be installed via `go get github.com/sqls-server/sqls`. Instructions for compiling Sqls from the source can be found at [sqls-server/sqls](https://github.com/sqls-server/sqls).

    ]],
  },
}
