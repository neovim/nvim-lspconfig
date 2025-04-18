---@brief
---
--- https://github.com/thought-machine/please
---
--- High-performance extensible build system for reproducible multi-language builds.
---
--- The `plz` binary will automatically install the LSP for you on first run
return {
  cmd = { 'plz', 'tool', 'lps' },
  filetypes = { 'bzl' },
  root_markers = { '.plzconfig' },
}
