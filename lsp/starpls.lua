---@brief
---
--- https://github.com/withered-magic/starpls
---
--- `starpls` is an LSP implementation for Starlark. Installation instructions can be found in the project's README.
return {
  cmd = { 'starpls' },
  filetypes = { 'bzl' },
  root_markers = { 'WORKSPACE', 'WORKSPACE.bazel', 'MODULE.bazel' },
}
