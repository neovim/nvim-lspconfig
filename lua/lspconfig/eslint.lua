local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local lsp = vim.lsp

local get_eslint_client = function()
  local active_clients = lsp.get_active_clients()
  for _, client in ipairs(active_clients) do
    if client.name == 'eslint' then
      return client
    end
  end
  return nil
end
local function fix_all(opts)
  opts = opts or {}

  local eslint_lsp_client = get_eslint_client()
  if eslint_lsp_client == nil then
    return
  end

  local request
  if opts.sync or false then
    request = function(bufnr, method, params)
      eslint_lsp_client.request(method, params, nil, bufnr)
    end
  else
    request = function(bufnr, method, params)
      eslint_lsp_client.request_sync(method, params, nil, bufnr)
    end
  end

  local bufnr = util.validate_bufnr(opts.bufnr or 0)
  request(0, 'workspace/executeCommand', {
    command = 'eslint.applyAllFixes',
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = lsp.util.buf_versions[bufnr],
      },
    },
  })
end

local bin_name = 'vscode-eslint-language-server'
configs.eslint = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    root_dir = util.root_pattern('.eslintrc.json', '.eslintrc.js', 'package.json', 'tsconfig.json', '.git'),
    settings = {
      validate = 'off',
      packageManager = 'npm',
      useESLintClass = false,
      codeActionOnSave = {
        enable = false,
        mode = 'all',
      },
      format = false,
      quiet = false,
      onIgnoredFiles = 'off',
      run = 'onType',
      nodePath = vim.NIL,
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = 'separateLine',
        },
        showDocumentation = {
          enable = true,
        },
      },
    },
    handlers = {
      ['eslint/openDoc'] = function(_, result)
        if not result then
          return
        end
        vim.cmd('!open ' .. result.url)
        return {}
      end,
      ['eslint/confirmESLintExecution'] = function(_, result)
        if not result then
          return
        end
        return 4 -- approved
      end,
    },
  },
  commands = {
    EslintFixAll = {
      function()
        fix_all { sync = true, bufnr = 0 }
      end,
      description = 'Fix all eslint problems for this buffer',
    },
  },
  docs = {
    description = [[
https://github.com/hrsh7th/vscode-langservers-extracted

vscode-eslint-language-server: A linting engine for JavaScript / Typescript

`vscode-eslint-language-server` can be installed via `npm`:
```sh
npm i -g vscode-langservers-extracted
```

vscode-eslint-language-server provides an EslintFixAll command that can be used to format document on save
```vim
autocmd BufWritePre <buffer> <cmd>EslintFixAll<CR>
```

See https://github.com/microsoft/vscode-eslint/blob/55871979d7af184bf09af491b6ea35ebd56822cf/server/src/eslintServer.ts#L216-L229 for configuration options.

Additional messages you can handle: eslint/probeFailed, eslint/noLibrary, eslint/noConfig
Messages already handled in lspconfig: eslint/openDoc, eslint/confirmESLintExecution
]],
  },
}

configs.eslint.fix_all = fix_all
