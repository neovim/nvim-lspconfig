return {
  default_config = {
    cmd = { 'starpls' },
    filetypes = { 'bzl' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find({ 'WORKSPACE', 'WORKSPACE.bazel', 'MODULE.bazel' }, { path = fname, upward = true })[1]
      )
    end,
  },
  docs = {
    description = [[
https://github.com/withered-magic/starpls

`starpls` is an LSP implementation for Starlark. Installation instructions can be found in the project's README.
]],
  },
}
