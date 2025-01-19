return {
  default_config = {
    cmd = { 'uiua', 'lsp' },
    filetypes = { 'uiua' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'main.ua', '.fmt.ua', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/uiua-lang/uiua/

The builtin language server of the Uiua interpreter.

The Uiua interpreter can be installed with `cargo install uiua`
]],
  },
}
