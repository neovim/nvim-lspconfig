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

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'rome'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
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
