return {
  default_config = {
    cmd = { 'kcl-language-server' },
    filetypes = { 'kcl' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/kcl-lang/kcl.nvim

Language server for the KCL configuration and policy language.

]],
  },
}
