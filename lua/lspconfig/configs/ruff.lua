local util = require 'lspconfig.util'

local function execute_command(command)
  local bufnr = vim.api.nvim_get_current_buf()
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'ruff', method = 'workspace/executeCommand' })[1]
  if client == nil then
    return
  end

  if vim.fn.has 'nvim-0.11' == 1 then
    return client:exec_cmd({
      title = command,
      command = command,
      arguments = {
        {
          uri = vim.uri_from_bufnr(bufnr),
          version = vim.lsp.util.buf_versions[bufnr],
        },
      },
    }, { bufnr = bufnr })
  end

  client.request('workspace/executeCommand', {
    command = command,
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = vim.lsp.util.buf_versions[bufnr],
      },
    },
  }, nil, bufnr)
end

return {
  default_config = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_dir = function(fname)
      return util.root_pattern('pyproject.toml', 'ruff.toml', '.ruff.toml')(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    settings = {},
  },
  commands = {
    RuffFixAll = {
      function()
        execute_command('ruff.applyAutofix')
      end,
      description = 'Fix all auto-fixable problems in the current buffer',
    },
    RuffOrganizeImports = {
      function()
        execute_command('ruff.applyOrganizeImports')
      end,
      description = 'Organize imports in the current buffer ',
    },
    RuffFormat = {
      function()
        execute_command('ruff.applyFormat')
      end,
      description = 'Format the current buffer',
    },
  },
  docs = {
    description = [[
https://github.com/astral-sh/ruff

A Language Server Protocol implementation for Ruff, an extremely fast Python linter and code formatter, written in Rust. It can be installed via `pip`.

```sh
pip install ruff
```

**Available in Ruff `v0.4.5` in beta and stabilized in Ruff `v0.5.3`.**

This is the new built-in language server written in Rust. It supports the same feature set as `ruff-lsp`, but with superior performance and no installation required. Note that the `ruff-lsp` server will continue to be maintained until further notice.

Server settings can be provided via:

```lua
require('lspconfig').ruff.setup({
  init_options = {
    settings = {
      -- Server settings should go here
    }
  }
})
```

Refer to the [documentation](https://docs.astral.sh/ruff/editors/) for more details.
]],
  },
}
