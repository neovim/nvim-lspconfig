---@brief
---
--- https://github.com/ponylang/ponyc/tree/main/tools/pony-lsp
---
--- Language server for the Pony programming language

--- default settings for pony-lsp
local function default_settings()
  ---@type table{ defines: string[], ponypath: string[] }
  return {
    defines = {},
    ponypath = {},
  }
end

---@type vim.lsp.Config
return {
  cmd = { 'pony-lsp' },
  filetypes = { 'pony' },
  root_markers = { 'corral.json', '.git' },
  settings = {
    ['pony-lsp'] = default_settings(),
  },
}
