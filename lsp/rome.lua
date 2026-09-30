---@brief
---
--- https://rome.tools
---
--- Language server for the Rome Frontend Toolchain.
---
--- (Unmaintained, use [Biome](https://biomejs.dev/blog/annoucing-biome) instead.)
---
--- ```sh
--- npm install [-g] rome
--- ```

local function get_cmd(cmd, root_dir)
  if not root_dir then
    return cmd
  end

  local lockfiles = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  local workspace_root = vim.fs.root(root_dir, lockfiles) or vim.fs.root(root_dir, '.git') or root_dir
  local dir = root_dir
  while dir do
    local local_cmd = vim.fs.joinpath(dir, 'node_modules/.bin', cmd)
    if vim.fn.executable(local_cmd) == 1 then
      return local_cmd
    end
    if dir == workspace_root then
      break
    end
    dir = vim.fs.dirname(dir)
  end
  return cmd
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = get_cmd('rome', (config or {}).root_dir)
    return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'json',
    'typescript',
    'typescriptreact',
  },
  root_markers = { 'package.json', 'node_modules', '.git' },
}
