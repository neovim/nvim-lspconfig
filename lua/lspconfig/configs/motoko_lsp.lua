return {
  default_config = {
    cmd = { 'motoko-lsp', '--stdio' },
    filetypes = { 'motoko' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'dfx.json', '.git' }, { path = fname, upward = true })[1])
    end,
    init_options = {
      formatter = 'auto',
    },
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/dfinity/vscode-motoko

Language server for the Motoko programming language.
    ]],
  },
}
