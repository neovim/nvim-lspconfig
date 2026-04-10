--- @brief
--- https://github.com/bufbuild/buf
---
--- buf lsp included in the cli itself
---
--- buf lsp is a Protobuf language server compatible with Buf modules and workspaces
---
--- buf lsp also supports Buf configuration files. The `buf-config` filetype is not
--- detected automatically; register it manually (see below) or override the filetypes:
---
--- ```lua
--- vim.filetype.add({
---   filename = {
---     ['buf.yaml'] = 'buf-config',
---     ['buf.gen.yaml'] = 'buf-config',
---     ['buf.policy.yaml'] = 'buf-config',
---     ['buf.lock'] = 'buf-config',
---   },
--- })
--- ```
---
--- Optionally, tell treesitter to treat buf config files as YAML for syntax highlighting:
---
--- ```lua
--- vim.treesitter.language.register('yaml', 'buf-config')
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'buf', 'lsp', 'serve', '--log-format=text' },
  filetypes = { 'proto', 'buf-config' },
  root_markers = { 'buf.yaml', '.git' },
  reuse_client = function(client, config)
    -- `buf lsp serve` is meant to be used with multiple workspaces.
    return client.name == config.name
  end,
}
