local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'cds-lsp', '--stdio' },
    filetypes = { 'cds' },
    -- init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
    root_dir = util.root_pattern('package.json', 'db', 'srv'),
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
