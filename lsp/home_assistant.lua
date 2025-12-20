---@brief
---
--- https://github.com/keesschollaart81/vscode-home-assistant
---
--- `vscode-home-assistant` can be installed via from source or by downloading
--- and extracting the VSCode "Home Assistant Config Helper" extension
---
--- `vscode-home-assistant` is a language server for Home Assistant ported from the VSCode "Home Assistant Config Helper" extension.

---@type vim.lsp.Config
return {
  cmd = { 'vscode-home-assistant', '--stdio' },
  filetypes = { 'yaml' },
  root_markers = {
    'configuration.yaml',
    'configuration.yml',
  },
}
