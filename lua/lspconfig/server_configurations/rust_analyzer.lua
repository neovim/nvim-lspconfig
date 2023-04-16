local util = require 'lspconfig.util'
local uv = vim.loop

local function reload_workspace(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  vim.lsp.buf_request(bufnr, 'rust-analyzer/reloadWorkspace', nil, function(err)
    if err then
      error(tostring(err))
    end
    vim.notify 'Cargo workspace reloaded'
  end)
end

local function get_workspace_dir(args)
  local co = coroutine.running()
  print(co)
  if not co then
    return
  end

  local function safe_close(handle)
    if not uv.is_closing(handle) then
      uv.close(handle)
    end
  end

  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local chunks = {}
  local handle
  handle = uv.spawn('cargo', {
    args = args,
    cwd = uv.cwd(),
    stdio = { nil, stdout, stderr },
  }, function(err, code)
    safe_close(stdout)
    safe_close(stderr)
    safe_close(handle)
    if next(chunks) == nil then
      return
    end

    local data = table.concat(chunks, '')
    chunks = vim.json.decode(data)
    local workspace_root = chunks and chunks['workspace_root'] or nil
    print(workspace_root, 'on_exit', coroutine.status(co))
    coroutine.resume(co, workspace_root)
  end)

  stdout:read_start(function(err, data)
    assert(not err)
    if data then
      chunks[#chunks + 1] = data
    end
  end)

  stderr:read_start(function(err, data)
    assert(not err)
    if data then
      vim.notify(string.format('[lspconfig] cmd (%q) failed:\n%s', table.concat(args, ' '), data), vim.log.levels.WARN)
    end
  end)
  print 'in dir'
  return coroutine.yield()
end

return {
  default_config = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_dir = function(fname)
      local cargo_crate_dir = util.root_pattern 'Cargo.toml'(fname)
      local args = { 'metadata', '--no-deps', '--format-version', '1' }
      if cargo_crate_dir ~= nil then
        args[#args + 1] = '--manifest-path'
        args[#args + 1] = util.path.join(cargo_crate_dir, 'Cargo.toml')
      end

      local dir = function()
        return get_workspace_dir(args)
      end

      local co = coroutine.create(function()
        print 'here'
        local result = dir()
        print 'here1'
        coroutine.yield(result)
      end)
      local _, cargo_workspace_root = coroutine.resume(co)

      print(cargo_workspace_root, coroutine.status(co), co)

      if cargo_workspace_root then
        cargo_workspace_root = util.path.sanitize(cargo_workspace_root)
      end

      print 'end'
      return cargo_workspace_root
        or cargo_crate_dir
        or util.root_pattern 'rust-project.json'(fname)
        or util.find_git_ancestor(fname)
    end,
  },
  commands = {
    CargoReload = {
      function()
        reload_workspace(0)
      end,
      description = 'Reload current cargo workspace',
    },
  },
  docs = {
    description = [[
https://github.com/rust-analyzer/rust-analyzer

rust-analyzer (aka rls 2.0), a language server for Rust


See [docs](https://github.com/rust-analyzer/rust-analyzer/tree/master/docs/user#settings) for extra settings. The settings can be used like this:
```lua
require'lspconfig'.rust_analyzer.setup{
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
}
```
    ]],
    default_config = {
      root_dir = [[root_pattern("Cargo.toml", "rust-project.json")]],
    },
  },
}
