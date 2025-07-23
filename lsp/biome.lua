---@brief
--- https://biomejs.dev
---
--- Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).
---
--- ```sh
--- npm install [-g] @biomejs/biome
--- ```

local util = require 'lspconfig.util'

return {
  cmd = function(dispatchers, config)
    local cmd = 'biome'
    local local_cmd = (config or {}).root_dir and config.root_dir .. '/node_modules/.bin/biome'
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
    return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
  end,
  filetypes = {
    'astro',
    'css',
    'graphql',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
    'vue',
  },
  workspace_required = true,
  root_dir = function(_, on_dir)
    -- To support monorepos, biome recommends starting the search for the root from cwd
    -- https://biomejs.dev/guides/big-projects/#use-multiple-configuration-files
    local cwd = vim.fn.getcwd()
    local root_files = { 'biome.json', 'biome.jsonc' }
    root_files = util.insert_package_json(root_files, 'biome', cwd)
    local root_dir = vim.fs.dirname(vim.fs.find(root_files, { path = cwd, upward = true })[1])
    on_dir(root_dir)
  end,
}
