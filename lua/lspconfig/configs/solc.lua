return {
  default_config = {
    cmd = { 'solc', '--lsp' },
    filetypes = { 'solidity' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'hardhat.config.*', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://docs.soliditylang.org/en/latest/installing-solidity.html

solc is the native language server for the Solidity language.
]],
  },
}
