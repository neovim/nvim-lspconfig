---@brief
---
--- https://mise.jdx.dev/ide-integration.html#language-server
---
--- Language server for [mise](https://mise.jdx.dev) config files, built into the `mise` binary (v2026.10.18 or later).
--- It provides diagnostics, completion, hover, formatting, and task navigation for `mise.toml`, `.mise.toml`,
--- `mise.local.toml`, `mise.<env>.toml`, `mise/config.toml`, and the files of a `conf.d` directory. It ignores every
--- other TOML file.
---
--- `mise` can be installed by following the instructions [here](https://mise.jdx.dev/installing-mise.html).
---
--- If another TOML server (such as `taplo` or `tombi`) is attached to the same buffers, hover, completion, and
--- formatting appear twice. To keep only what mise adds, turn those capabilities off:
---
--- ```lua
--- vim.lsp.config('mise', {
---   init_options = { formatting = false, hover = false, completion = false },
--- })
--- ```

local root_markers = {
  'mise.toml',
  '.mise.toml',
  'mise.local.toml',
  '.mise.local.toml',
  'mise/config.toml',
  '.mise/config.toml',
  '.config/mise/config.toml',
}

---@type vim.lsp.Config
return {
  cmd = { 'mise', 'lsp' },
  filetypes = { 'toml' },
  root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers } or root_markers,
}
