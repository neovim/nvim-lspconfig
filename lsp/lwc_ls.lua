---@brief
---
--- https://github.com/forcedotcom/lightning-language-server/
---
--- Language server for Lightning Web Components.
---
--- For manual installation, utilize the official [NPM package](https://www.npmjs.com/package/@salesforce/lwc-language-server).
--- Then, configure `cmd` to run the Node script at the unpacked location:
---
--- ```lua
--- vim.lsp.config('lwc_ls', {
---   cmd = {
---     'node',
---     '/path/to/node_modules/@salesforce/lwc-language-server/bin/lwc-language-server.js',
---     '--stdio'
---   }
--- })
--- ```
return {
  cmd = { 'lwc-language-server', '--stdio' },
  filetypes = { 'javascript', 'html' },
  root_markers = { 'sfdx-project.json' },
  init_options = {
    embeddedLanguages = {
      javascript = true,
    },
  },
}
