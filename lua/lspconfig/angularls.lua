local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'angularls'
local bin_name = server_name
local install_loc = util.base_install_dir .. '/' .. server_name
local script_loc = install_loc .. '/node_modules/@angular/language-server/index.js'
local bin_loc = install_loc .. '/node_modules/.bin/angularls'

local installer = util.npm_installer {
  server_name = server_name;
  packages = { '@angular/language-server' };
  binaries = { bin_name };
  -- angular-language-service doesn't expose a binary, so we create an execution wrapper.
  post_install_script =
    'echo "#! /bin/sh\n' .. 'node ' .. script_loc .. ' \\$*' .. '" > ' .. bin_loc .. '\n' ..
    'chmod +x ' .. bin_loc;
}

-- Angular requires a node_modules directory to probe for @angular/language-service and typescript
-- in order to use your projects configured versions.
-- This defaults to the vim cwd, but will get overwritten by the resolved root of the file.
local function get_probe_dir(root_dir)
  local project_root = util.find_node_modules_ancestor(root_dir)

  return project_root and (project_root .. '/node_modules') or ''
end

local default_probe_dir = get_probe_dir(vim.fn.getcwd())

configs[server_name] = {
  default_config = {
    cmd = {
      bin_loc,
      '--stdio',
      '--tsProbeLocations', default_probe_dir,
      '--ngProbeLocations', default_probe_dir
    };
    filetypes = {'typescript', 'html', 'typescriptreact', 'typescript.tsx'};
    -- Check for angular.json or .git first since that is the root of the project.
    -- Don't check for tsconfig.json or package.json since there are multiple of these
    -- in an angular monorepo setup.
    root_dir = util.root_pattern('angular.json', '.git');
  };
  on_new_config = function(new_config, new_root_dir)
    local new_probe_dir = get_probe_dir(new_root_dir)

    -- We need to check our probe directories because they may have changed.
    new_config.cmd = {
      bin_loc,
      '--stdio',
      '--tsProbeLocations', new_probe_dir,
      '--ngProbeLocations', new_probe_dir
    }
  end;
  docs = {
    description = [[
https://github.com/angular/vscode-ng-language-service

`angular-language-server` can be installed via `:LspInstall angularls`

If you prefer to install this yourself you can through npm `npm install @angular/language-server`.
Be aware there is no global binary and must be run via `node_modules/@angular/language-server/index.js`
    ]];
    default_config = {
      root_dir = [[root_pattern("angular.json", ".git")]];
    };
  }
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
