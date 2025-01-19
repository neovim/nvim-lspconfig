return {
  default_config = {
    cmd = { 'clarity-lsp' },
    filetypes = { 'clar', 'clarity' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
`clarity-lsp` is a language server for the Clarity language. Clarity is a decidable smart contract language that optimizes for predictability and security. Smart contracts allow developers to encode essential business logic on a blockchain.

To learn how to configure the clarity language server, see the [clarity-lsp documentation](https://github.com/hirosystems/clarity-lsp).
]],
  },
}
