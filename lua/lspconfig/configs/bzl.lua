return {
  default_config = {
    cmd = { 'bzl', 'lsp', 'serve' },
    filetypes = { 'bzl' },
    -- https://docs.bazel.build/versions/5.4.1/build-ref.html#workspace
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'WORKSPACE', 'WORKSPACE.bazel' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://bzl.io/

https://docs.stack.build/docs/cli/installation

https://docs.stack.build/docs/vscode/starlark-language-server
]],
  },
}
