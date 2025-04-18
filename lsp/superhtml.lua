---@brief
---
--- https://github.com/kristoff-it/superhtml
---
--- HTML Language Server & Templating Language Library
---
--- This LSP is designed to tightly adhere to the HTML spec as well as enforcing
--- some additional rules that ensure HTML clarity.
---
--- If you want to disable HTML support for another HTML LSP, add the following
--- to your configuration:
---
--- ```lua
--- vim.lsp.config('superhtml', {
---   filetypes = { 'superhtml' }
--- })
--- ```
return {
  cmd = { 'superhtml', 'lsp' },
  filetypes = { 'superhtml', 'html' },
  root_markers = { '.git' },
}
