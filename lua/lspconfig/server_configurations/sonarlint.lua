local util = require 'lspconfig.util'

local tcp = vim.loop.new_tcp()
tcp:bind('127.0.0.1', 0)
local port = tostring(tcp:getsockname().port)

local root_files = {
  'compile_commands.json',
  '.ccls',

  'package.json',
  'tsconfig.json',

  'composer.json',

  '.git',
}

return {
  default_config = {
    cmd = { 'nc', '-l', port },
    filetypes = { 'c', 'cpp', 'html', 'javascript', 'php', 'python', 'typescript', 'xml' },
    root_dir = function(file, bufnr)
      if (vim.fn.getbufvar(bufnr, '&filetype')) ~= 'python' then
        return util.root_pattern(root_files)(file)
      end
    end,
    single_file_support = true,
    handlers = {
      ['sonarlint/isOpenInEditor'] = function(_, file_uri)
        local buf = vim.uri_to_bufnr(file_uri)
        return vim.api.nvim_buf_is_valid(buf)
      end,
      ['sonarlint/isIgnoredByScm'] = function(_, file_uri)
        local output = vim.fn.system('git check-ignore ' .. vim.uri_from_fname(file_uri))
        if vim.v.shell_error == 128 or (vim.v.shell_error ~= 128 and output == '') then
          return 'false'
        else
          return 'true'
        end
      end,
    },
    settings = { sonarlint = { disableTelemetry = true } },
    before_init = function(_, config)
      if not config.sonarlint_dir then
        error 'config.sonarlint_dir is not set'
      end

      local sonarlint_cmd = {
        'java',
        '-jar',
        util.path.join(config.sonarlint_dir, 'server/sonarlint-ls.jar'),
        port,
        '-analyzers',
      }

      vim.list_extend(
        sonarlint_cmd,
        vim.tbl_map(function(analyzer)
          local analyzer_dir = util.path.join(config.sonarlint_dir, string.format('analyzers/sonar%s.jar', analyzer))
          return analyzer_dir
        end, { 'cfamily', 'html', 'js', 'php', 'python', 'xml' })
      )

      table.insert(sonarlint_cmd, '-extraAnalyzers')
      table.insert(sonarlint_cmd, util.path.join(config.sonarlint_dir, 'analyzers/sonarsecrets.jar'))

      vim.fn.jobstart(sonarlint_cmd)
    end,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/SonarSource/sonarlint-vscode/master/package.json',
    description = [[
https://github.com/SonarSource/sonarlint-vscode
SonarLint.
[Download](https://github.com/SonarSource/sonarlint-vscode/releases) and extract SonarLint VSCode extension. The
extension can be extracted using a zip file tool like `unzip`. The extracted files' directory structure should look like
this:
```
sonarlint/
├─ extension/
│  ├─ analyzers/
│  ├─ server/
```
```lua
require('lspconfig').sonarlint.setup {
  -- Must be set and point to sonarlint/extension
  sonarlint_dir = '/path/to/sonarlint/extension',
}
```
]],
  },
}
