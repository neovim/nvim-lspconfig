local util = require 'lspconfig.util'

local function reload_workspace(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  vim.lsp.buf_request(bufnr, 'rust-analyzer/reloadWorkspace', nil, function(err)
    if err then
      error(tostring(err))
    end
    vim.notify 'Cargo workspace reloaded'
  end)
end

local function get_workspace_dir(cmd)
  local co = assert(coroutine.running())

  local chunks = {}
  local jobid = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      chunks[#chunks + 1] = unpack(data)
    end,
    on_stderr = function(_, data, _)
      vim.api.nvim_err_write(table.concat(data, '\n'))
    end,
    on_exit = function()
      if next(chunks) == nil then
        coroutine.resume(co, nil)
        return
      end

      local data = table.concat(chunks, '')
      chunks = vim.json.decode(data)
      local workspace_root = chunks and chunks['workspace_root'] or nil
      coroutine.resume(co, workspace_root)
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })

  if jobid < 0 then
    vim.api.nvim_err_writeln('Failed to start cargo metadata job id:' .. jobid)
    return
  end

  return (coroutine.yield())
end

return {
  default_config = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_dir = function(fname)
      local cargo_crate_dir = util.root_pattern 'Cargo.toml'(fname)
      local cmd = { 'cargo', 'metadata', '--no-deps', '--format-version', '1' }
      if cargo_crate_dir ~= nil then
        cmd[#cmd + 1] = '--manifest-path'
        cmd[#cmd + 1] = util.path.join(cargo_crate_dir, 'Cargo.toml')
      end

      local cargo_workspace_root = get_workspace_dir(cmd)

      if cargo_workspace_root then
        cargo_workspace_root = util.path.sanitize(cargo_workspace_root)
      end

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
