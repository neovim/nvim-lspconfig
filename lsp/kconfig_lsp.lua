---@brief
---
--- https://github.com/cccheng/kconfig-lsp
---
--- Language server for Kconfig, the configuration language of Linux, Zephyr, U-Boot, coreboot and
--- other projects. It can be installed via `cargo`:
--- ```sh
--- cargo install kconfig-lsp
--- ```
---
--- To accept the Kconfig extensions of Zephyr, such as `configdefault` and `def_int`:
--- ```lua
--- vim.lsp.config('kconfig_lsp', {
---   init_options = { zephyr_extensions = true },
--- })
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'kconfig-lsp' },
  filetypes = { 'kconfig' },
  root_markers = { '.git', 'Kconfig' },
}
