---@brief
---
--- https://github.com/juanfranblanco/vscode-solidity
---
--- `vscode-solidity-server` can be installed via `npm`:
---
--- ```sh
--- npm install -g vscode-solidity-server
--- ```
---
--- `vscode-solidity-server` is a language server for the Solidity language ported from the VSCode "solidity" extension.
return {
  cmd = { 'vscode-solidity-server', '--stdio' },
  filetypes = { 'solidity' },
  root_markers = {
    'hardhat.config.js',
    'hardhat.config.ts',
    'foundry.toml',
    'remappings.txt',
    'truffle.js',
    'truffle-config.js',
    'ape-config.yaml',
    '.git',
    'package.json',
  },
}
