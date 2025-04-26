---@brief
---
--- https://github.com/microsoft/azure-pipelines-language-server
---
--- An Azure Pipelines language server
---
--- `azure-pipelines-ls` can be installed via `npm`:
---
--- ```sh
--- npm install -g azure-pipelines-language-server
--- ```
---
--- By default `azure-pipelines-ls` will only work in files named `azure-pipelines.yml`, this can be changed by providing additional settings like so:
--- ```lua
--- vim.lsp.config('azure_pipelines_ls', {
---   ... -- other configuration
---   settings = {
---       yaml = {
---           schemas = {
---               ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
---                   "/azure-pipeline*.y*l",
---                   "/*.azure*",
---                   "Azure-Pipelines/**/*.y*l",
---                   "Pipelines/*.y*l",
---               },
---           },
---       },
---   },
--- })
--- ```
--- The Azure Pipelines LSP is a fork of `yaml-language-server` and as such the same settings can be passed to it as `yaml-language-server`.
return {
  cmd = { 'azure-pipelines-language-server', '--stdio' },
  filetypes = { 'yaml' },
  root_markers = { 'azure-pipelines.yml' },
  settings = {},
}
