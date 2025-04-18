---@brief
---
--- https://github.com/facebook/buck2
---
--- Build system, successor to Buck
---
--- To better detect Buck2 project files, the following can be added:
---
--- ```
--- vim.cmd [[ autocmd BufRead,BufNewFile *.bxl,BUCK,TARGETS set filetype=bzl ]]
--- ```
return {
  cmd = { 'buck2', 'lsp' },
  filetypes = { 'bzl' },
  root_markers = { '.buckconfig' },
}
