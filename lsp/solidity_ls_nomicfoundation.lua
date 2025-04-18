---@brief
---
--- https://github.com/NomicFoundation/hardhat-vscode/blob/development/server/README.md
---
--- `nomicfoundation-solidity-language-server` can be installed via `npm`:
---
--- ```sh
--- npm install -g @nomicfoundation/solidity-language-server
--- ```
---
--- A language server for the Solidity programming language, built by the Nomic Foundation for the Ethereum community.
return {
  cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
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
