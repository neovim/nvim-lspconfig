local bin_name = 'theme-check-language-server'

---@brief
---
-- https://github.com/Shopify/shopify-cli
--
-- `theme-check-language-server` is bundled with `shopify-cli` or it can also be installed via
--
-- https://github.com/Shopify/theme-check#installation
--
-- **NOTE:**
-- If installed via Homebrew, `cmd` must be set to 'theme-check-liquid-server'
--
-- ```lua
-- vim.lsp.config('theme_check, {
--   cmd = { 'theme-check-liquid-server' }
-- })
-- ```
return {
  cmd = { bin_name, '--stdio' },
  filetypes = { 'liquid' },
  root_markers = { '.theme-check.yml' },
  settings = {},
}
