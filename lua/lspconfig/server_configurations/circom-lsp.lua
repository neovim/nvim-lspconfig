local util = require 'lspconfig.util'

local root_files = {
  'package.json',
  'tsconfig.json',
  'pyproject.toml',
  'Cargo.toml',
}

return {
  default_config = {
    cmd = { 'circom-lsp' },
    filetypes = { 'circom' },
    root_dir = function()
      local root = util.root_pattern(root_files)(vim.fn.expand '%:p')
      return root or vim.api.nvim_buf_get_name(0)
    end,
  },
  docs = {
    description = [[
[Circom Language Server](https://github.com/rubydusa/circom-lsp)

`circom-lsp`, the language server for the Circom language.
    ]],
  },
}
