---@brief
---
--- https://bzl.io/
---
--- https://docs.stack.build/docs/cli/installation
---
--- https://docs.stack.build/docs/vscode/starlark-language-server
return {
  cmd = { 'bzl', 'lsp', 'serve' },
  filetypes = { 'bzl' },
  -- https://docs.bazel.build/versions/5.4.1/build-ref.html#workspace
  root_markers = { 'WORKSPACE', 'WORKSPACE.bazel' },
}
