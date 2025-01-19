return {
  default_config = {
    cmd = { 'hydra-lsp' },
    filetypes = { 'yaml' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/Retsediv/hydra-lsp

LSP for Hydra Python package config files.
]],
  },
}
