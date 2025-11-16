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

--- Recursively solve for the original ngserver path on Windows
-- For a given ngserver path:
--   - If it is not a CMD wrapper, return the path;
--   - Or else, extract the path from the CMD wrapper.
--
-- @param cmd_path (string) path for the ngserver executable or its CMD wrapper.
-- @return (string) the original executable path for ngserver
-- @usage
-- -- Base case: cmd_path already points to ngserver (expected behavior on Linux)
-- resolve_cmd_shim('/home/user/project/node_modules/@angular/language-server/bin/ngserver')
-- => '/home/user/project/node_modules/@angular/language-server/bin/ngserver'
--
-- -- Recursive case: cmd_path points to a CMD wrapper (Windows)
-- resolve_cmd_shim('C:/Users/user/project/node_modules/.bin/ngserver.cmd')
-- => 'C:/Users/user/project/node_modules/@angular/language-server/bin/ngserver'
local function resolve_cmd_shim(cmd_path)
  if not cmd_path:lower():match('%ngserver.cmd$') then
    return cmd_path
  end

  local ok, content = pcall(fn.readblob, cmd_path)
  if not ok or not content then
    return cmd_path
  end

  local target = content:match('%s%"%%dp0%%\\([^\r\n]-ngserver[^\r\n]-)%"')
  if not target then
    return cmd_path
  end

  local full = fs.normalize(fs.joinpath(fs.dirname(cmd_path), target))

  return resolve_cmd_shim(full)
end

local function collect_node_modules(root_dir)
  local results = {}

  local project_node = fs.joinpath(root_dir, 'node_modules')
  if uv.fs_stat(project_node) then
    table.insert(results, project_node)
  end

  local ngserver_exe = fn.exepath('ngserver')
  if ngserver_exe and #ngserver_exe > 0 then
    local realpath = uv.fs_realpath(ngserver_exe) or ngserver_exe
    realpath = resolve_cmd_shim(realpath)
    local candidate = fs.normalize(fs.joinpath(fs.dirname(realpath), '../../..'))
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

  local ok, content = pcall(fn.readblob, package_json)
  if not ok or not content then
    return ''
  end

  local json = vim.json.decode(content) or {}

  local version = (json.dependencies or {})['@angular/core'] or ''
  return version:match('%d+%.%d+%.%d+') or ''
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local root_dir = (config and config.root_dir) or fn.getcwd()
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
