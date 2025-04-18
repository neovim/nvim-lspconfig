---@brief
---
--- https://github.com/forcedotcom/salesforcedx-vscode
---
--- Language server for Visualforce.
---
--- For manual installation, download the .vsix archive file from the
--- [forcedotcom/salesforcedx-vscode](https://github.com/forcedotcom/salesforcedx-vscode)
--- GitHub releases. Then, configure `cmd` to run the Node script at the unpacked location:
---
--- ```lua
--- vim.lsp.config('visualforce_ls', {
---   cmd = {
---     'node',
---     '/path/to/unpacked/archive/extension/node_modules/@salesforce/salesforcedx-visualforce-language-server/out/src/visualforceServer.js',
---     '--stdio'
---   }
--- })
--- ```
return {
  filetypes = { 'visualforce' },
  root_markers = { 'sfdx-project.json' },
  init_options = {
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
  },
}
