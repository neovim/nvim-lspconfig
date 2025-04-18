---@brief
---
--- https://github.com/nextflow-io/language-server
---
--- Requirements:
---  - Java 17+
---
--- `nextflow_ls` can be installed by following the instructions [here](https://github.com/nextflow-io/language-server#development).
---
--- If you have installed nextflow language server, you can set the `cmd` custom path as follow:
---
--- ```lua
--- vim.lsp.config('nextflow_ls', {
---     cmd = { 'java', '-jar', 'nextflow-language-server-all.jar' },
---     filetypes = { 'nextflow' },
---     settings = {
---       nextflow = {
---         files = {
---           exclude = { '.git', '.nf-test', 'work' },
---         },
---       },
---     },
--- })
--- ```
return {
  cmd = { 'java', '-jar', 'nextflow-language-server-all.jar' },
  filetypes = { 'nextflow' },
  root_markers = { 'nextflow.config', '.git' },
  settings = {
    nextflow = {
      files = {
        exclude = { '.git', '.nf-test', 'work' },
      },
    },
  },
}
