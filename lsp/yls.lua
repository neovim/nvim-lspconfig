---@brief
---
--- https://pypi.org/project/yls-yara/
---
--- An YLS plugin adding YARA linting capabilities.
---
--- This plugin runs yara.compile on every save, parses the errors, and returns list of diagnostic messages.
---
--- Language Server: https://github.com/avast/yls
return {
  cmd = { 'yls', '-vv' },
  filetypes = { 'yar', 'yara' },
  root_markers = { '.git' },
}
