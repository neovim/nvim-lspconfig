local util = require 'lspconfig.util'

local bin_name = 'vscode-css-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local workspace_markers = { 'package.json', '.git' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'css', 'scss', 'less' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
    settings = {
      css = { validate = true },
      scss = { validate = true },
      less = { validate = true },
    },
  },
  docs = {
    description = [[

https://github.com/hrsh7th/vscode-langservers-extracted

`css-languageserver` can be installed via `npm`:

```sh
npm i -g vscode-langservers-extracted
```

Neovim does not currently include built-in snippets. `vscode-css-language-server` only provides completions when snippet support is enabled. To enable completion, install a snippet plugin and add the following override to your language client capabilities during setup.

```lua
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.cssls.setup {
  capabilities = capabilities,
}
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
