---@brief
---
--- https://github.com/nokia/ntt
--- Installation instructions can be found [here](https://github.com/nokia/ntt#Install).
--- Can be configured by passing a "settings" object to vim.lsp.config('ntt'):
--- ```lua
--- vim.lsp.config('ntt', {
---     settings = {
---       ntt = {
---       }
---     }
--- })
--- ```

return {
  cmd = { 'ntt', 'langserver' },
  filetypes = { 'ttcn' },
  root_markers = { '.git' },
}
