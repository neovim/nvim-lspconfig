---@brief
--- https://github.com/Open-MBEE/OpenSysML
---
--- SysML v2 and KerML language server from OpenSysML.
---
--- Install from the release archives, or with Go:
---
--- ```sh
--- go install github.com/Open-MBEE/OpenSysML/cmd/sysml-lsp@latest
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'sysml-lsp', '--stdio' },
  filetypes = { 'sysml', 'kerml' },
  root_markers = { '.git' },
  workspace_required = false,
}
