return {
  default_config = {
    cmd = { 'ecsact_lsp_server', '--stdio' },
    filetypes = { 'ecsact' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },

  docs = {
    description = [[
https://github.com/ecsact-dev/ecsact_lsp_server

Language server for Ecsact.

The default cmd assumes `ecsact_lsp_server` is in your PATH. Typically from the
Ecsact SDK: https://ecsact.dev/start
]],
  },
}
