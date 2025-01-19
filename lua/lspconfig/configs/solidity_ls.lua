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
    cmd = { 'vscode-solidity-server', '--stdio' },
    filetypes = { 'solidity' },
    root_dir = function(fname)
      vim.fs.dirname(vim.fs.find({ unpack(root_files), '.git', 'package.json' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/juanfranblanco/vscode-solidity

`vscode-solidity-server` can be installed via `npm`:

```sh
npm install -g vscode-solidity-server
```

`vscode-solidity-server` is a language server for the Solidity language ported from the VSCode "solidity" extension.
]],
  },
}
