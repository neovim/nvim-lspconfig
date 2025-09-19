---@brief
---
--- https://github.com/JohnnyMorganz/StyLua
---
--- A deterministic code formatter for Lua 5.1, 5.2, 5.3, 5.4, LuaJIT, Luau and CfxLua/FiveM Lua

---@type vim.lsp.Config
return {
  cmd = { 'stylua', '--lsp' },
  -- server looks for configuration in CWD only, does not use rootUri
  reuse_client = function(client, config)
    config.cmd_cwd = config.root_dir
    return client.config.cmd_cwd == config.cmd_cwd
  end,
  filetypes = { 'lua' },
  root_markers = { '.stylua.toml', 'stylua.toml' },
}
