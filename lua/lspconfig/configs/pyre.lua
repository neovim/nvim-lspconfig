return {
  default_config = {
    cmd = { 'pyre', 'persistent' },
    filetypes = { 'python' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.pyre_configuration' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://pyre-check.org/

`pyre` a static type checker for Python 3.

`pyre` offers an extremely limited featureset. It currently only supports diagnostics,
which are triggered on save.

Do not report issues for missing features in `pyre` to `lspconfig`.

]],
  },
}
