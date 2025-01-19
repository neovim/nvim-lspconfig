return {
  default_config = {
    cmd = { 'cds-lsp', '--stdio' },
    filetypes = { 'cds' },
    -- init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'package.json', 'db', 'srv' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    settings = {
      cds = { validate = true },
    },
  },
  docs = {
    description = [[

https://cap.cloud.sap/docs/

`cds-lsp` can be installed via `npm`:

```sh
npm i -g @sap/cds-lsp
```

]],
  },
}
