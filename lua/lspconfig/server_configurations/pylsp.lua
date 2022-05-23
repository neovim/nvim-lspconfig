local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'pylsp' },
    filetypes = { 'python' },
    root_dir = function(fname)
      local root_files = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
      }
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/python-lsp/python-lsp-server

A Python 3.6+ implementation of the Language Server Protocol.

The language server can be installed via `pipx install 'python-lsp-server[all]'`.
Further instructions can be found in the [project's README](https://github.com/python-lsp/python-lsp-server).

Note: This is a community fork of `pyls`.

**Enabling/disabling plugins:**
- Disable `mccabe` complexity checking (enabled by default), enable `pylint` (disabled by default), and add `E501` (line too long) error to ignore list: 
```lua
require('lspconfig').pylsp.setup {
  on_attach = on_attach,
  flags = {
    -- This will be the default in neovim 0.7+
    debounce_text_changes = 150,
  },
  settings = {
    pylsp = {
      plugins = {
        mccabe = { enabled = false },
        pylint = { enabled = true },
        pycodestyle = { ignore = {'E501'} }
      }
    }
  }
}
```

You can use [williamboman/nvim-lsp-installer](https://github.com/williamboman/nvim-lsp-installer) to find a listing of all the plugins and their settings.

    ]],
  },
}
