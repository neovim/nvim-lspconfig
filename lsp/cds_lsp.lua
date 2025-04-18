---@brief
---
--- https://cap.cloud.sap/docs/
---
--- `cds-lsp` can be installed via `npm`:
---
--- ```sh
--- npm i -g @sap/cds-lsp
--- ```
return {
  cmd = { 'cds-lsp', '--stdio' },
  filetypes = { 'cds' },
  -- init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
  root_markers = { 'package.json', 'db', 'srv' },
  settings = {
    cds = { validate = true },
  },
}
