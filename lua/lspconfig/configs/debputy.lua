return {
  default_config = {
    cmd = { 'debputy', 'lsp', 'server' },
    filetypes = { 'debcontrol', 'debcopyright', 'debchangelog', 'make', 'yaml' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'debian' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://salsa.debian.org/debian/debputy

Language Server for Debian packages.
]],
  },
}
