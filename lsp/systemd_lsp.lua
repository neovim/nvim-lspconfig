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
--- local systemd_unit_extensions = { -- Credit to @magnuslarsen
---   -- systemd unit files
---   'service',
---   'socket',
---   'timer',
---   'mount',
---   'automount',
---   'swap',
---   'target',
---   'path',
---   'slice',
---   'scope',
---   'device',
---   -- Podman Quadlet files
---   'container',
---   'volume',
---   'network',
---   'kube',
---   'pod',
---   'build',
---   'image'
--- }
---
--- local extension_map = {}
--- for _, exts in ipairs(systemd_unit_extensions) do
---   extension_map[exts] = 'systemd'
--- end
---
--- vim.filetype.add {
---   extension = extension_map
--- }
-- ```


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

    for _, ft in ipairs(systemd_unit_filetypes) do
      on_dir((util.root_pattern(ft))(fname))
    end
  end,
}
