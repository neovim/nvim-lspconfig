---@brief
---
--- https://github.com/luizcorreia/spectral-language-server
---  `A flexible JSON/YAML linter for creating automated style guides, with baked in support for OpenAPI v2 & v3.`
---
--- `spectral-language-server` can be installed via `npm`:
--- ```sh
--- npm i -g spectral-language-server
--- ```
--- See [vscode-spectral](https://github.com/stoplightio/vscode-spectral#extension-settings) for configuration options.

return {
  cmd = { 'spectral-language-server', '--stdio' },
  filetypes = { 'yaml', 'json', 'yml' },
  root_markers = { '.spectral.yaml', '.spectral.yml', '.spectral.json', '.spectral.js' },
  settings = {
    enable = true,
    run = 'onType',
    validateLanguages = { 'yaml', 'json', 'yml' },
  },
}
