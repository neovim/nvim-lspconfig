return {
  default_config = {
    cmd = { 'circom-lsp' },
    filetypes = { 'circom' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
[Circom Language Server](https://github.com/rubydusa/circom-lsp)

`circom-lsp`, the language server for the Circom language.
    ]],
  },
}
