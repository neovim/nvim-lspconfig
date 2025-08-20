---@brief
---
--- https://github.com/tilt-dev/tilt
---
--- Tilt language server.
---
--- You might need to add filetype detection manually:
---
--- ```vim
--- autocmd BufRead Tiltfile setf=tiltfile
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'tilt', 'lsp', 'start' },
  filetypes = { 'tiltfile' },
  root_markers = { '.git' },
}
