---@brief
---
--- https://github.com/Beaglefoot/awk-language-server/
---
--- `awk-language-server` can be installed via `npm`:
--- ```sh
--- npm install -g awk-language-server
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'awk-language-server' },
  filetypes = { 'awk' },
}
