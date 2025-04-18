---@brief
---
---A language server for Solidity
---
--- See the [documentation](https://solang.readthedocs.io/en/latest/installing.html) for installation instructions.
---
--- The language server only provides the following capabilities:
--- * Syntax highlighting
--- * Diagnostics
--- * Hover
---
--- There is currently no support for completion, goto definition, references, or other functionality.
return {
  cmd = { 'solang', 'language-server', '--target', 'evm' },
  filetypes = { 'solidity' },
  root_markers = { '.git' },
}
