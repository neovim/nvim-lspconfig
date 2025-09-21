local util = require 'lspconfig.util'
local lsp = vim.lsp

local function fix_all(opts)
  opts = opts or {}

  local eslint_lsp_client = vim.lsp.get_clients({ bufnr = opts.bufnr, name = 'eslint' })[1]
  if eslint_lsp_client == nil then
    return
  end

  local request
  if opts.sync then
    request = function(bufnr, method, params)
      eslint_lsp_client.request_sync(method, params, nil, bufnr)
    end
  else
    request = function(bufnr, method, params)
      eslint_lsp_client.request(method, params, nil, bufnr)
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

local eslint_config_files = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
  'eslint.config.js',
  'eslint.config.mjs',
  'eslint.config.cjs',
  'eslint.config.ts',
  'eslint.config.mts',
  'eslint.config.cts',
}

return {
  default_config = {
    cmd = { 'vscode-eslint-language-server', '--stdio' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'vue',
      'svelte',
      'astro',
    },
    -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
    root_dir = function(filename)
      local bufnr = vim.api.nvim_buf_get_number(filename)
      -- The project root is where the LSP can be started from
      -- As stated in the documentation above, this LSP supports monorepos and simple projects.
      -- We select then from the project root, which is identified by the presence of a package
      -- manager lock file.
      local root_markers = { 'git', 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
      -- We fallback to the current working directory if no project root is found
      local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

      -- We know that the buffer is using ESLint if it has a config file
      -- in its directory tree.
      --
      -- Eslint used to support package.json files as config files, but it doesn't anymore.
      -- We keep this for backward compatibility.
      local eslint_config_files_with_package_json =
        util.insert_package_json(eslint_config_files, 'eslintConfig', filename)
      local is_buffer_using_eslint = vim.fs.find(eslint_config_files_with_package_json, {
        path = filename,
        type = 'file',
        limit = 1,
        upward = true,
        stop = vim.fs.dirname(project_root),
      })[1]
      if not is_buffer_using_eslint then
        return
      end

      return project_root
    end,
    -- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
    settings = {
      validate = 'on',
      packageManager = nil,
      useESLintClass = false,
      experimental = {
        useFlatConfig = false,
      },
      codeActionOnSave = {
        enable = false,
        mode = 'all',
      },
      format = true,
      quiet = false,
      onIgnoredFiles = 'off',
      rulesCustomizations = {},
      run = 'onType',
      problems = {
        shortenToSingleLine = false,
      },
      -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
      -- This path is relative to the workspace folder (root dir) of the server instance.
      nodePath = '',
      -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
      workingDirectory = { mode = 'location' },
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
    on_new_config = function(config, new_root_dir)
      -- The "workspaceFolder" is a VSCode concept. It limits how far the
      -- server will traverse the file system when locating the ESLint config
      -- file (e.g., .eslintrc).
      local root_dir = new_root_dir

      if root_dir then
        config.settings = config.settings or {}
        config.settings.workspaceFolder = {
          uri = root_dir,
          name = vim.fn.fnamemodify(root_dir, ':t'),
        }

        -- Support flat config files
        -- They contain 'config' in the file name
        local flat_config_files = vim.tbl_filter(function(file)
          return file:match('config')
        end, eslint_config_files)

        for _, file in ipairs(flat_config_files) do
          local found_files = vim.fn.globpath(root_dir, file, true, true)

          -- Filter out files inside node_modules
          local filtered_files = {}
          for _, found_file in ipairs(found_files) do
            if string.find(found_file, '[/\\]node_modules[/\\]') == nil then
              table.insert(filtered_files, found_file)
            end
          end

          if #filtered_files > 0 then
            config.settings.experimental = config.settings.experimental or {}
            config.settings.experimental.useFlatConfig = true
            break
          end
        end

        -- Support Yarn2 (PnP) projects
        local pnp_cjs = root_dir .. '/.pnp.cjs'
        local pnp_js = root_dir .. '/.pnp.js'
        if vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js) then
          local cmd = config.cmd
          config.cmd = vim.list_extend({ 'yarn', 'exec' }, cmd)
        end
      end
    end,
    handlers = {
      ['eslint/openDoc'] = function(_, result)
        if result then
          vim.ui.open(result.url)
        end
        return {}
      end,
      ['eslint/confirmESLintExecution'] = function(_, result)
        if not result then
          return
        end
        return 4 -- approved
      end,
      ['eslint/probeFailed'] = function()
        vim.notify('[lspconfig] ESLint probe failed.', vim.log.levels.WARN)
        return {}
      end,
      ['eslint/noLibrary'] = function()
        vim.notify('[lspconfig] Unable to find ESLint library.', vim.log.levels.WARN)
        return {}
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

`vscode-eslint-language-server` is a linting engine for JavaScript / Typescript.
It can be installed via `npm`:

```sh
npm i -g vscode-langservers-extracted
```

`vscode-eslint-language-server` provides an `EslintFixAll` command that can be used to format a document on save:
```lua
lspconfig.eslint.setup({
  --- ...
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})
```

See [vscode-eslint](https://github.com/microsoft/vscode-eslint/blob/55871979d7af184bf09af491b6ea35ebd56822cf/server/src/eslintServer.ts#L216-L229) for configuration options.

Messages handled in lspconfig: `eslint/openDoc`, `eslint/confirmESLintExecution`, `eslint/probeFailed`, `eslint/noLibrary`

Additional messages you can handle: `eslint/noConfig`
]],
  },
}
