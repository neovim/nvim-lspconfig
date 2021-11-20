local util = require 'lspconfig.util'
local uv = vim.loop

local bin_name = 'ngserver'
local args = {
  '--stdio',
}

local cmd = { bin_name, unpack(args) }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, unpack(args) }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx' },
    -- Check for angular.json or .git first since that is the root of the project.
    -- Don't check for tsconfig.json or package.json since there are multiple of these
    -- in an angular monorepo setup.
    root_dir = util.root_pattern('angular.json', '.git'),
  },
  on_new_config = function(new_config, new_root_dir)
    -- Angular requires a node_modules directory to probe for @angular/language-service
    -- and typescript in order to use your projects configured versions.
    local node_root = util.find_node_modules_ancestor(new_root_dir)

    if not node_root then
      return
    end

    local node_modules_path = util.path.join(node_root, 'node_modules')

    new_config.cmd = {
      'ngserver',
      '--stdio',
      '--tsProbeLocations',
      node_modules_path,
      '--ngProbeLocations',
      node_modules_path,
    }

    local angular_package_json = util.path.join(node_modules_path, '@angular', 'core', 'package.json')

    -- Checking if we should provide legacy support
    local fd = uv.fs_open(angular_package_json, 'r', 438)
    if not fd then
      return
    end

    local stat = uv.fs_fstat(fd)
    local data = uv.fs_read(fd, stat.size, 0)
    uv.fs_close(fd)
    local decoded_json = vim.fn.json_decode(data)
    local version = vim.split(decoded_json.version, '.', true)
    if tonumber(version[1]) < 9 then
      table.insert(new_config.cmd, '--viewEngine')
    end
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
    default_config = {
      root_dir = [[root_pattern("angular.json", ".git")]],
    },
  },
}
