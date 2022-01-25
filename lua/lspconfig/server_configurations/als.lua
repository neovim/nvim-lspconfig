local util = require 'lspconfig.util'
local bin_name = 'ada_language_server'

if vim.fn.has 'win32' == 1 then
  bin_name = 'ada_language_server.exe'
end

return {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'ada' },
    root_dir = util.root_pattern('Makefile', '.git', '*.gpr', '*.adc'),
    lspinfo = function(cfg)
      local extra = {}
      local function find_gpr_project()
        local function split(inputstr, sep)
          if sep == nil then
            sep = '%s'
          end
          local t = {}
          for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
            table.insert(t, str)
          end
          return t
        end
        local projectfiles = split(vim.fn.glob(cfg.root_dir .. '/*.gpr'))
        if #projectfiles == 0 then
          return 'None (error)'
        elseif #projectfiles == 1 then
          return projectfiles[1]
        else
          return 'Ambiguous (error)'
        end
      end
      table.insert(extra, 'GPR project:     ' .. ((cfg.settings.ada or {}).projectFile or find_gpr_project()))
      return extra
    end,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/AdaCore/ada_language_server/master/integration/vscode/ada/package.json',
    description = [[
https://github.com/AdaCore/ada_language_server

Installation instructions can be found [here](https://github.com/AdaCore/ada_language_server#Install).

Can be configured by passing a "settings" object to `als.setup{}`:

```lua
require('lspconfig').als.setup{
    settings = {
      ada = {
        projectFile = "project.gpr";
        scenarioVariables = { ... };
      }
    }
}
```
]],
    default_config = {
      root_dir = [[util.root_pattern("Makefile", ".git", "*.gpr", "*.adc")]],
    },
  },
}
