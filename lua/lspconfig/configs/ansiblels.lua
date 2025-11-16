-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ansible-language-server', '--stdio' },
    settings = {
      ansible = {
        python = {
          interpreterPath = 'python',
        },
        ansible = {
          path = 'ansible',
        },
        executionEnvironment = {
          enabled = false,
        },
        validation = {
          enabled = true,
          lint = {
            enabled = true,
            path = 'ansible-lint',
          },
        },
      },
    },
    filetypes = { 'yaml.ansible' },
    root_dir = util.root_pattern('ansible.cfg', '.ansible-lint'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/ansible/vscode-ansible

Language server for the ansible configuration management tool.

`ansible-language-server` can be installed via `npm`:

```sh
npm install -g @ansible/ansible-language-server
```
]],
  },
}
