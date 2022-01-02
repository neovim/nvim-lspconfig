local util = require 'lspconfig.util'

local root_files = {
  'package.json',
  'tsconfig.json',

  'build.xml',
  'pom.xml',
  'settings.gradle',
  'settings.gradle.kts',
  'build.gradle',
  'build.gradle.kts',

  'composer.json',

  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',

  '.git',
}

local get_sonarlint_client = function()
  local active_clients = vim.lsp.get_active_clients()
  for _, client in ipairs(active_clients) do
    if client.name == 'sonarlint' then
      return client
    end
  end
  return nil
end

local toggle_rule = function(level)
  return function(k)
    local rule_key = (type(k) == 'table' and k.arguments[1]) or k
    local sonarlint_settings = get_sonarlint_client().config.settings.sonarlint
    sonarlint_settings.rules = sonarlint_settings.rules or {}
    sonarlint_settings.rules[rule_key] = {
      level = level,
    }
    vim.lsp.buf_notify(nil, 'workspace/didChangeConfiguration')
  end
end

local list_all_rules = function()
  vim.lsp.buf_request(0, 'sonarlint/listAllRules', nil, function(_, result)
    local text = {}
    for repo, rules in pairs(result) do
      table.insert(text, repo)
      for _, rule in ipairs(rules) do
        table.insert(
          text,
          string.format('  %s - %s [default: %s]', rule.key, rule.name, (rule.activeByDefault and 'on') or 'off')
        )
      end
    end
    vim.cmd 'tabnew'
    vim.cmd 'setlocal buftype=nofile'
    vim.cmd 'setlocal bufhidden=hide'
    vim.cmd 'setlocal noswapfile'
    vim.fn.setline(1, text)
    vim.cmd 'setlocal readonly'
  end)
end

--[[
TODO: Unimplemented method handlers:
  Server side handlers:
    '$/setTraceNotification'
    'sonarlint/didClasspathUpdate' (*)
    'sonarlint/didJavaServerModeChange' (*)
    'sonarlint/didLocalBranchNameChange'
  Client side handlers:
    'sonarlint/showSonarLintOutput'
    'sonarlint/openJavaHomeSettings'
    'sonarlint/openPathToNodeSettings'
    'sonarlint/openConnectionSettings'
    'sonarlint/showRuleDescription'
    'sonarlint/showHotspot'
    'sonarlint/showTaintVulnerability'
    'sonarlint/isIgnoredByScm'
    'sonarlint/showNotificationForFirstSecretsIssue'
    'sonarlint/getJavaConfig' (*)
    'sonarlint/browseTo'
    'sonarlint/getBranchNameForFolder'

(*) These method handlers must be implemented to enable Java analysis
]]

return {
  default_config = {
    cmd = { 'nc', '-l', '18689' },
    filetypes = { 'html', 'java', 'javascript', 'php', 'python', 'typescript' },
    root_dir = util.root_pattern(root_files),
    single_file_support = true,
    settings = { sonarlint = { disableTelemetry = true } },
    commands = {
      ['SonarLint.DeactivateRule'] = toggle_rule 'off',
    },
    before_init = function(_, config)
      if not config.sonarlint_dir then
        error 'config.sonarlint_dir is not set'
      end

      local sonarlint_cmd = {
        'java',
        '-jar',
        util.path.join(config.sonarlint_dir, 'server/sonarlint-ls.jar'),
        '18689',
        '-analyzers',
      }

      vim.list_extend(
        sonarlint_cmd,
        vim.tbl_map(function(analyzer)
          local analyzer_dir = util.path.join(config.sonarlint_dir, string.format('analyzers/sonar%s.jar', analyzer))
          return 'file://' .. analyzer_dir
        end, { 'html', 'java', 'js', 'php', 'python' })
      )

      table.insert(sonarlint_cmd, '-extraAnalyzers')
      table.insert(sonarlint_cmd, 'file://' .. util.path.join(config.sonarlint_dir, 'analyzers/sonarsecrets.jar'))

      vim.fn.jobstart(sonarlint_cmd)
    end,
  },
  commands = {
    SonarLintListAllRules = {
      list_all_rules,
    },
    SonarLintActivateRule = {
      toggle_rule 'on',
      '-nargs=1',
    },
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
