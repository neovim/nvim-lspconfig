return {
  -- Configuration from https://github.com/iamcco/diagnostic-languageserver#config--document
  default_config = {
    cmd = { 'diagnostic-languageserver', '--stdio' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    -- Empty by default, override to add filetypes.
    filetypes = {},
  },
  docs = {
    description = [[
https://github.com/iamcco/diagnostic-languageserver

Diagnostic language server integrate with linters.
]],
  },
}
