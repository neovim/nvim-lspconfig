---@brief
---
--- https://github.com/angular/vscode-ng-language-service
--- `angular-language-server` can be installed via npm `npm install -g @angular/language-server`.
---
--- ```lua
--- local project_library_path = "/path/to/project/lib"
--- local cmd = {"ngserver", "--stdio", "--tsProbeLocations", project_library_path , "--ngProbeLocations", project_library_path}
---
--- vim.lsp.config('angularls', {
---   cmd = cmd,
--- })
--- ```

-- Angular requires a node_modules directory to probe for @angular/language-service and typescript
-- in order to use your projects configured versions.
local fs, fn, uv = vim.fs, vim.fn, vim.uv

local function collect_node_modules(root_dir)
  local results = {}

  local project_node = fs.joinpath(root_dir, 'node_modules')
  if uv.fs_stat(project_node) then
    table.insert(results, project_node)
  end

  local ngserver_exe = fn.exepath('ngserver')
  if ngserver_exe and #ngserver_exe > 0 then
    local realpath = uv.fs_realpath(ngserver_exe) or ngserver_exe
    local candidate = fs.normalize(fs.joinpath(fs.dirname(realpath), '../../node_modules'))
    if uv.fs_stat(candidate) then
      table.insert(results, candidate)
    end
  end

  local internal_servers = fn.globpath(fn.stdpath('data'), '**/node_modules/.bin/ngserver', true, true)
  for _, exe in ipairs(internal_servers) do
    local realpath = uv.fs_realpath(exe) or exe
    local candidate = fs.normalize(fs.joinpath(fs.dirname(realpath), '../../node_modules'))
    if uv.fs_stat(candidate) then
      table.insert(results, candidate)
    end
  end

  return results
end

local function get_angular_core_version(root_dir)
  local package_json = fs.joinpath(root_dir, 'package.json')
  if not uv.fs_stat(package_json) then
    return ''
  end

  local ok, f = pcall(io.open, package_json, 'r')
  if not ok or not f then
    return ''
  end

  local json = vim.json.decode(f:read('*a')) or {}
  f:close()

  local version = (json.dependencies or {})['@angular/core'] or ''
  return version:match('%d+%.%d+%.%d+') or ''
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local root_dir = (config and config.root) or fn.getcwd()
    local node_paths = collect_node_modules(root_dir)

    local ts_probe = table.concat(node_paths, ',')
    local ng_probe = table.concat(
      vim
        .iter(node_paths)
        :map(function(p)
          return fs.joinpath(p, '@angular/language-server/node_modules')
        end)
        :totable(),
      ','
    )
    local cmd = {
      'ngserver',
      '--stdio',
      '--tsProbeLocations',
      ts_probe,
      '--ngProbeLocations',
      ng_probe,
      '--angularCoreVersion',
      get_angular_core_version(root_dir),
    }
    return vim.lsp.rpc.start(cmd, dispatchers)
  end,

  filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'htmlangular' },
  root_markers = { 'angular.json', 'nx.json' },
}
