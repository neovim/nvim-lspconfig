---@brief
---
--- https://github.com/barrettruth/vimdoc-language-server
---
--- Language server for vim help files (vimdoc).
---
--- `vimdoc-language-server` can be installed via `cargo`:
--- ```sh
--- cargo install vimdoc-language-server
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'vimdoc-language-server' },
  filetypes = { 'help' },
  root_markers = { 'doc', '.git' },
  workspace_required = false,
}
