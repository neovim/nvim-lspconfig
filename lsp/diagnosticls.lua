---@brief
---
--- https://github.com/iamcco/diagnostic-languageserver
---
--- Diagnostic language server integrate with linters.
return {
  -- Configuration from https://github.com/iamcco/diagnostic-languageserver#config--document
  cmd = { 'diagnostic-languageserver', '--stdio' },
  -- Empty by default, override to add filetypes.
  filetypes = {},
}
