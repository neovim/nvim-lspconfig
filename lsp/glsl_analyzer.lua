---@brief
---
--- https://github.com/nolanderc/glsl_analyzer
---
--- Language server for GLSL

---@type vim.lsp.Config
return {
  cmd = { 'glsl_analyzer' },
  filetypes = { 'glsl', 'vert', 'tesc', 'tese', 'frag', 'geom', 'comp' },
  root_markers = { '.git' },
  capabilities = {},
}
