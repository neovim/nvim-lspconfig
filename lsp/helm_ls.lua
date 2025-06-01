---@brief
---
--- https://github.com/mrjosh/helm-ls
---
--- Helm Language server. (This LSP is in early development)
---
--- `helm Language server` can be installed by following the instructions [here](https://github.com/mrjosh/helm-ls).
---
--- The default `cmd` assumes that the `helm_ls` binary can be found in `$PATH`.
---
--- If need Helm file highlight use [vim-helm](https://github.com/towolf/vim-helm) plugin.
return {
  cmd = { 'helm_ls', 'serve' },
  filetypes = { 'helm', 'yaml.helm-values' },
  root_markers = { 'Chart.yaml' },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
}
