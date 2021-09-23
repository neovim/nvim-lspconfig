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

configs.eslint = {
  default_config = {
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
      validate = 'on',
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = 'separateLine',
        },
        showDocumentation = {
          enable = true,
        },
      },
      codeActionOnSave = {
        enable = false,
        mode = 'all',
        rules = {},
      },
      format = false,
      quiet = false,
      onIgnoredFiles = 'off',
      options = nil,
      run = 'onType',
      nodePath = vim.NIL,
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
https://github.com/microsoft/vscode-eslint

A linting engine for JavaScript / Typescript

Setup: Run `npm install && npm run webpack` in the root and set the `cmd` to `{"node", PATH_TO_REPO .. "/server/out/eslintServer.js", "--stdio"}`

See https://github.com/microsoft/vscode-eslint/blob/55871979d7af184bf09af491b6ea35ebd56822cf/server/src/eslintServer.ts#L216-L229 for configuration options.

Additional messages you can handle: eslint/probeFailed, eslint/noLibrary, eslint/noConfig
Additional messages you can handle that are handled already in lspconfig: eslint/openDoc, eslint/confirmESLintExecution
]],
  },
}

configs.eslint.fix_all = fix_all
