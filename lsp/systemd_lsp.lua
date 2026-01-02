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
--- > If you want this LSP to accurately activate for any
--- > Systemd unit files, use the following settings:
---
--- ```lua
--- vim.filetype.add {
---   -- systemd unit filetypes
---   ['service'] = 'systemd',
---   ['socket'] = 'systemd',
---   ['timer'] = 'systemd',
---   ['mount'] = 'systemd',
---   ['automount'] = 'systemd',
---   ['swap'] = 'systemd',
---   ['target'] = 'systemd',
---   ['path'] = 'systemd',
---   ['slice'] = 'systemd',
---   ['scope'] = 'systemd',
---   ['device'] = 'systemd',
---   -- Podman Quadlet filetypes
---   ['container'] = 'systemd',
---   ['volume'] = 'systemd',
---   ['network'] = 'systemd',
---   ['kube'] = 'systemd',
---   ['pod'] = 'systemd',
---   ['build'] = 'systemd',
---   ['image'] = 'systemd',
--- }
--- ```


---@type vim.lsp.Config
return {
  cmd = { 'systemd-lsp' },
  filetypes = { 'systemd' },
  ---@param bufnr integer
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    local systemd_unit_filetypes = { -- Credit to @magnuslarsen
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
    }

    local util = require('lspconfig.util')

    on_dir((util.root_pattern(systemd_unit_filetypes))(fname))
  end,
}
