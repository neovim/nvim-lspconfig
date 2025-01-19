local root_files = {
  'hardhat.config.js',
  'hardhat.config.ts',
  'foundry.toml',
  'remappings.txt',
  'truffle.js',
  'truffle-config.js',
  'ape-config.yaml',
}

return {
  default_config = {
    cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
    filetypes = { 'solidity' },
    root_dir = function(fname)
      vim.fs.dirname(vim.fs.find({ unpack(root_files), '.git', 'package.json' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/NomicFoundation/hardhat-vscode/blob/development/server/README.md

`nomicfoundation-solidity-language-server` can be installed via `npm`:

```sh
npm install -g @nomicfoundation/solidity-language-server
```

A language server for the Solidity programming language, built by the Nomic Foundation for the Ethereum community.
]],
  },
}
