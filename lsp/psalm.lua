---@brief
---
--- https://github.com/vimeo/psalm
---
--- Can be installed with composer.
--- ```sh
--- composer global require vimeo/psalm
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'psalm', '--language-server' },
  filetypes = { 'php' },
  root_markers = { 'psalm.xml', 'psalm.xml.dist' },
}
