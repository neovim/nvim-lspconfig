---@brief
---
--- https://github.com/csskit/csskit
---
--- Beautiful, fast, and powerful CSS tooling with zero configuration
---
--- `csskit` can be installed via `npm`:
---
--- ```sh
--- npm i -g csskit
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'csskit', 'lsp' },
  filetypes = { 'css' },
  root_markers = { 'package.json', '.git' },
}
