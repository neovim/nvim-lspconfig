---@brief
---
--- https://github.com/move-language/move/tree/main/language/move-analyzer
---
--- Language server for Move
---
--- The `move-analyzer` can be installed by running:
---
--- ```
--- cargo install --git https://github.com/move-language/move move-analyzer
--- ```
---
--- See [`move-analyzer`'s doc](https://github.com/move-language/move/blob/1b258a06e3c7d2bc9174578aac92cca3ac19de71/language/move-analyzer/editors/code/README.md#how-to-install) for details.
return {
  cmd = { 'move-analyzer' },
  filetypes = { 'move' },
  root_markers = { 'Move.toml' },
}
