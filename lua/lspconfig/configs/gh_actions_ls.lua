local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'gh-actions-language-server', '--stdio' },
    filetypes = { 'yaml' },

    -- Only attach to yaml files that are GitHub workflows instead of all yaml
    -- files. (A nil root_dir and no single_file_support results in the LSP not
    -- attaching.) For details, see #3558
    root_dir = function(filename)
      return filename:find('/%.github/workflows/.+%.ya?ml') and util.root_pattern('.github')(filename) or nil
    end,
    -- Disabling "single file support" is a hack to avoid enabling this LS for
    -- every random yaml file, so `root_dir()` can control the enablement.
    single_file_support = false,

    capabilities = {
      workspace = {
        didChangeWorkspaceFolders = {
          dynamicRegistration = true,
        },
      },
    },
  },
  docs = {
    description = [[
https://github.com/lttb/gh-actions-language-server

Language server for GitHub Actions.

`gh-actions-language-server` can be installed via `npm`:

```sh
npm install -g gh-actions-language-server
```
]],
  },
}
