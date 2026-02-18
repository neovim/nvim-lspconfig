--- @brief
---
--- https://github.com/atusy/kakehashi
---
--- Tree-sitter-based language server that provides semantic tokens, selection ranges,
--- and LSP bridging for embedded languages (e.g., code blocks in Markdown).
---
--- kakehashi works with any language that has a Tree-sitter grammar.
--- Parsers and queries are automatically installed on first use
--- when `autoInstall` is enabled (the default). This requires the
--- `tree-sitter` CLI, a C compiler, and Git.
---
--- **You must specify `filetypes` in your call to `vim.lsp.config`** to
--- restrict which files activate the server:
---
--- ```lua
--- vim.lsp.config('kakehashi', {
---   filetypes = { 'markdown', 'lua', 'rust', 'python' },
---   init_options = {
---     autoInstall = true,
---     -- Optional: bridge LSP requests in injection regions
---     languageServers = {
---       ['lua_ls'] = {
---         cmd = { 'lua-language-server' },
---         languages = { 'lua' },
---       },
---     },
---     languages = {
---       markdown = {
---         bridge = { lua_ls = { enabled = true } },
---       },
---     },
---   },
--- })
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'kakehashi' },
  root_markers = { 'kakehashi.toml', '.git' },
}
