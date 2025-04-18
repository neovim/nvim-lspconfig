---@brief
---
--- https://pyre-check.org/
---
--- `pyre` a static type checker for Python 3.
---
--- `pyre` offers an extremely limited featureset. It currently only supports diagnostics,
--- which are triggered on save.
---
--- Do not report issues for missing features in `pyre` to `lspconfig`.
return {
  cmd = { 'pyre', 'persistent' },
  filetypes = { 'python' },
  root_markers = { '.pyre_configuration' },
}
