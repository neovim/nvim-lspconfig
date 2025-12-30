---@brief
---
--- https://github.com/JFryy/systemd-lsp
---
--- A Language Server Protocol (LSP) implementation for Systemd unit files,
--- providing editing support with syntax highlighting,
--- diagnostics, autocompletion, and documentation.
---
--- `systemd-lsp` can be installed via `cargo`:
--- ```sh
--- cargo install systemd-lsp
--- ```
---
--- A language server implementation for Systemd unit files made in Rust.
---
--- > [!NOTE]
--- >
--- > If you want this LSP to accurately activate for any Systemd files,
--- > make sure to use the following autocmd:
---
--- ```lua
--- vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
---  group = vim.api.nvim_create_augroup('systemd-filetypes', { clear = true }),
--   pattern = {
--     '*.service',
--     '*.mount',
--     '*.device',
--     '*.nspawn',
--     '*.target',
--     '*.timer',
--     '*.path',
--     '*.slice',
--     '*.socket',
--   },
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     vim.bo[bufnr].filetype = 'systemd'
--   end,
--   desc = 'Set filetype to systemd for systemd unit files',
-- })
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'systemd-lsp' },
  filetypes = { 'systemd' },
  root_pattern = { -- Credit to @magnuslarsen
    -- systemd unit files
    '*.service',
    '*.socket',
    '*.timer',
    '*.mount',
    '*.automount',
    '*.swap',
    '*.target',
    '*.path',
    '*.slice',
    '*.scope',
    '*.device',
    -- Podman Quadlet files
    '*.container',
    '*.volume',
    '*.network',
    '*.kube',
    '*.pod',
    '*.build',
    '*.image',
  },
}
