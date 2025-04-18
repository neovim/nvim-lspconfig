---@brief
---
--- https://github.com/wgsl-analyzer/wgsl-analyzer
---
--- `wgsl-analyzer` can be installed via `cargo`:
--- ```sh
--- cargo install --git https://github.com/wgsl-analyzer/wgsl-analyzer wgsl-analyzer
--- ```
return {
  cmd = { 'wgsl-analyzer' },
  filetypes = { 'wgsl' },
  root_markers = { '.git' },
  settings = {},
}
