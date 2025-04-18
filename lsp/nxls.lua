---@brief
---
--- https://github.com/nrwl/nx-console/tree/master/apps/nxls
---
--- nxls, a language server for Nx Workspaces
---
--- `nxls` can be installed via `npm`:
--- ```sh
--- npm i -g nxls
--- ```
return {
  cmd = { 'nxls', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { 'nx.json', '.git' },
}
