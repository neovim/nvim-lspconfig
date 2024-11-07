local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'java', '-jar', 'nextflow-language-server-all.jar' },
    filetypes = { 'nextflow' },
    root_dir = util.root_pattern('nextflow.config', '.git'),
    settings = {
      nextflow = {
        files = {
          exclude = { '.git', '.nf-test', 'work' },
        },
      },
    },
  },
  docs = {
    description = [[
https://github.com/nextflow-io/language-server

Requirements:
 - Java 17+

`nextflow_ls` can be installed by following the instructions [here](https://github.com/nextflow-io/language-server#development).

If you have installed nextflow language server, you can set the `cmd` custom path as follow:

```lua
require'lspconfig'.nextflow_ls.setup{
    cmd = { 'java', '-jar', 'nextflow-language-server-all.jar' },
    filetypes = { 'nextflow' },
    root_dir = util.root_pattern('nextflow.config', '.git'),
    settings = {
      nextflow = {
        files = {
          exclude = { '.git', '.nf-test', 'work' },
        },
      },
    },
}
```
]],
  },
}
