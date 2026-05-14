---@brief
---
--- https://github.com/EmmyLuaLs/emmylua-analyzer-rust
---
--- EmmyluaLs, a language server for Lua.
---
--- `emmylua_ls` can be installed using `cargo` by following the [instructions](https://github.com/EmmyLuaLs/emmylua-analyzer-rust#install).
---
--- The default `cmd` assumes that the `emmylua_ls` binary can be found in `$PATH`.
--- You may want to symlink to the cargo artifact:
--- ```
--- ln -s $(pwd)/target/release/emmylua_ls ~/bin/emmylua_ls
--- ```
---
--- See the emmylua_ls [configuration guide](https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/main/docs/config/emmyrc_json_EN.md)
--- for settings documentation.

--- If you want completions and analysis for Neovim plugins on your runtime path, try this config:
---
--- ```lua
--- vim.lsp.config('emmylua_ls', {
---   on_init = function(client)
---     -- If the workspace has its own emmylua_ls/lua_ls config file, defer to it.
---     if client.workspace_folders then
---       local path = client.workspace_folders[1].name
---       if
---         path ~= vim.fn.stdpath('config')
---         and (vim.uv.fs_stat(path .. '/.emmyrc.json') or vim.uv.fs_stat(path .. '/.luarc.json'))
---       then
---         client.config.settings = {}
---       end
---     end
---   end,
---   settings = {
---     emmylua = {
---       -- Tell the server which Lua you're using (usually LuaJIT, for Neovim).
---       runtime = { version = 'LuaJIT' },
---       diagnostics = { globals = { 'vim' } },
---       -- Make the server aware of Neovim runtime files.
---       workspace = {
---         library = {
---           vim.env.VIMRUNTIME,
---           -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
---           vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
---         },
---         -- Or pull in all of 'runtimepath'. May be slower! https://github.com/neovim/nvim-lspconfig/issues/3189
---         -- library = vim.api.nvim_get_runtime_file('', true),
---       },
---     },
---   },
--- })
--- ```

local root_markers1 = {
  '.emmyrc.json',
  '.emmyrc.lua',
  '.luarc.json',
  '.luarc.jsonc',
}
local root_markers2 = {
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
}

---@type vim.lsp.Config
return {
  cmd = { 'emmylua_ls' },
  filetypes = { 'lua' },
  root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers1, root_markers2, { '.git' } }
    or vim.list_extend(vim.list_extend(root_markers1, root_markers2), { '.git' }),
  workspace_required = false,
  settings = {
    codeLens = { enable = true },
    hint = { enable = true },
  },
}
