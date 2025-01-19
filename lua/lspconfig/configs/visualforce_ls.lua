return {
  default_config = {
    filetypes = { 'visualforce' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'sfdx-project.json' }, { path = fname, upward = true })[1])
    end,
    init_options = {
      embeddedLanguages = {
        css = true,
        javascript = true,
      },
    },
  },
  docs = {
    description = [[
https://github.com/forcedotcom/salesforcedx-vscode

Language server for Visualforce.

For manual installation, download the .vsix archive file from the
[forcedotcom/salesforcedx-vscode](https://github.com/forcedotcom/salesforcedx-vscode)
GitHub releases. Then, configure `cmd` to run the Node script at the unpacked location:

```lua
require'lspconfig'.visualforce_ls.setup {
  cmd = {
    'node',
    '/path/to/unpacked/archive/extension/node_modules/@salesforce/salesforcedx-visualforce-language-server/out/src/visualforceServer.js',
    '--stdio'
  }
}
```
]],
  },
}
