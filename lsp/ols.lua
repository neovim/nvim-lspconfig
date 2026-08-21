---@brief
---
--- https://github.com/DanielGavin/ols
---
--- `Odin Language Server`.

local util = require 'lspconfig.util'

---@return string?
local function default_odin_root()
  -- https://odin-lang.org/docs/install/#release-requirements--notes
  local odin_root = os.getenv('ODIN_ROOT')
  if odin_root ~= nil and odin_root ~= '' then
    return vim.fs.normalize(odin_root)
  end

  -- https://github.com/odin-lang/Odin/wiki/Compiler-Flags
  if vim.fn.executable('odin') == 0 then
    return
  end
  local result = vim.system({ 'odin', 'root' }, { text = true }):wait()
  if result.code == 0 and result.stdout ~= nil then
    local stdout = vim.trim(result.stdout)
    return stdout ~= '' and vim.fs.normalize(stdout) or nil
  end
end

---@param fname string
---@return string?
local function is_library(fname)
  local odin_root = default_odin_root()
  if odin_root == nil then
    return nil
  end

  fname = vim.fs.normalize(fname)
  for _, lib in ipairs({ 'base', 'core', 'vendor' }) do
    if vim.fs.relpath(vim.fs.joinpath(odin_root, lib), fname) ~= nil then
      local clients = vim.lsp.get_clients({ name = 'ols' })
      return #clients > 0 and clients[#clients].config.root_dir or nil
    end
  end
end

---@type vim.lsp.Config
return {
  cmd = { 'ols' },
  filetypes = { 'odin' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local reused_dir = is_library(fname)
    if reused_dir then
      on_dir(reused_dir)
      return
    end

    on_dir(util.root_pattern('ols.json', '.git', '*.odin')(fname))
  end,
}
