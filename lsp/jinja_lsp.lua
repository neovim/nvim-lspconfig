---@brief
---
--- jinja-lsp enhances minijinja development experience by providing Helix/Nvim users with advanced features such as autocomplete, syntax highlighting, hover, goto definition, code actions and linting.
---
--- The file types are not detected automatically, you can register them manually (see below) or override the filetypes:
---
--- ```lua
--- vim.filetype.add {
---   extension = {
---     jinja = 'jinja',
---     jinja2 = 'jinja',
---     j2 = 'jinja',
---   },
--- }
--- ```
return {
  name = 'jinja_lsp',
  cmd = { 'jinja-lsp' },
  filetypes = { 'jinja' },
  root_markers = { '.git' },
}
