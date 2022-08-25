local util = require 'lspconfig.util'

local bin_name = 'stylelint-lsp'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local function fix_all(opts)
  opts = opts or { sync = true, bufnr = 0 }
  local bufnr = util.validate_bufnr(opts.bufnr or 0)

  local stylelint_lsp_client = util.get_active_client_by_name(bufnr, 'stylelint_lsp')
  if stylelint_lsp_client == nil then
    return
  end

  local request
  if opts.sync then
    request = function(buf, method, params)
      stylelint_lsp_client.request_sync(method, params, nil, buf)
    end
  else
    request = function(buf, method, params)
      stylelint_lsp_client.request(method, params, nil, buf)
    end
  end

  request(bufnr, 'workspace/executeCommand', {
    command = 'stylelint.applyAutoFixes',
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = vim.lsp.util.buf_versions[bufnr],
      },
    },
  })
end

return {
  default_config = {
    cmd = cmd,
    filetypes = {
      'css',
      'less',
      'scss',
      'sugarss',
      'vue',
      'wxss',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    root_dir = util.root_pattern('.stylelintrc', 'package.json'),
    settings = {},
    commands = {
      StylelintFixAll = {
        function()
          fix_all { sync = true, bufnr = 0 }
        end,
        description = 'Fix all stylelint problems for this buffer',
      },
    },
  },
  docs = {
    description = [[
https://github.com/bmatcuk/stylelint-lsp

`stylelint-lsp` can be installed via `npm`:

```sh
npm i -g stylelint-lsp
```

Can be configured by passing a `settings.stylelintplus` object to `stylelint_lsp.setup`:

```lua
require'lspconfig'.stylelint_lsp.setup{
  settings = {
    stylelintplus = {
      -- see available options in stylelint-lsp documentation
    }
  }
}
```

`stylelint_lsp` provides a `StylelintFixAll` command that can be used to format a document on save:

```lua
local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local autoformat_workaround = ag('lsp_format_workaround', {})
au('BufWritePre', {
  group = autoformat_workaround,
  pattern = { '*.css', '*.scss', },
  command = 'StylelintFixAll',
})
```
]]   ,
    default_config = {
      root_dir = [[ root_pattern('.stylelintrc', 'package.json') ]],
    },
  },
}
