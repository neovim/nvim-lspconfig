local util = require 'lspconfig.util'

-- Angular requires a node_modules directory to probe for @angular/language-service and typescript
-- in order to use your projects configured versions.
-- This defaults to the vim cwd, but will get overwritten by the resolved root of the file.
local function get_probe_dir(root_dir)
  local project_root = vim.fs.dirname(vim.fs.find('node_modules', { path = root_dir, upward = true })[1])

  return project_root and (project_root .. '/node_modules') or ''
end

local function get_angular_core_version(root_dir)
  local project_root = vim.fs.dirname(vim.fs.find('node_modules', { path = root_dir, upward = true })[1])

  if not project_root then
    return ''
  end

  local package_json = project_root .. '/package.json'
  if not vim.uv.fs_stat(package_json) then
    return ''
  end

  local contents = io.open(package_json):read '*a'
  local json = vim.json.decode(contents)
  if not json.dependencies then
    return ''
  end

  local angular_core_version = json.dependencies['@angular/core']

  angular_core_version = angular_core_version and angular_core_version:match('%d+%.%d+%.%d+')

  return angular_core_version
end

local default_probe_dir = get_probe_dir(vim.fn.getcwd())
local default_angular_core_version = get_angular_core_version(vim.fn.getcwd())

return {
  default_config = {
    cmd = {
      'ngserver',
      '--stdio',
      '--tsProbeLocations',
      default_probe_dir,
      '--ngProbeLocations',
      default_probe_dir,
      '--angularCoreVersion',
      default_angular_core_version,
    },
    filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'htmlangular' },
    -- Check for angular.json since that is the root of the project.
    -- Don't check for tsconfig.json or package.json since there are multiple of these
    -- in an angular monorepo setup.
    root_dir = util.root_pattern 'angular.json',
  },
  on_new_config = function(new_config, new_root_dir)
    local new_probe_dir = get_probe_dir(new_root_dir)
    local angular_core_version = get_angular_core_version(new_root_dir)

    -- We need to check our probe directories because they may have changed.
    new_config.cmd = {
      vim.fn.exepath('ngserver'),
      '--stdio',
      '--tsProbeLocations',
      new_probe_dir,
      '--ngProbeLocations',
      new_probe_dir,
      '--angularCoreVersion',
      angular_core_version,
    }
  end,
  docs = {
    description = [[
https://github.com/angular/vscode-ng-language-service

`angular-language-server` can be installed via npm `npm install -g @angular/language-server`.

Note, that if you override the default `cmd`, you must also update `on_new_config` to set `new_config.cmd` during startup.

```lua
local project_library_path = "/path/to/project/lib"
local cmd = {"ngserver", "--stdio", "--tsProbeLocations", project_library_path , "--ngProbeLocations", project_library_path}

require'lspconfig'.angularls.setup{
  cmd = cmd,
  on_new_config = function(new_config,new_root_dir)
    new_config.cmd = cmd
  end,
}
```
    ]],
  },
}
