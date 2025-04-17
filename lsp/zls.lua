---@brief
-- https://github.com/zigtools/zls
--
-- Zig LSP implementation + Zig Language Server

return {
  cmd = { 'zls' },
  filetypes = { 'zig', 'zir' },
  root_markers = { 'zls.json', 'build.zig' },
  workspace_required = false,
}
