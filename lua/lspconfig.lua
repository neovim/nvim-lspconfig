local configs = require 'lspconfig/configs'

local M = {
  util = require 'lspconfig/util';
}

M._root = {}

function M.available_servers()
  return vim.tbl_keys(configs)
end

local mt = {}
function mt:__index(k)
  if configs[k] == nil then
    require('lspconfig/'..k)
  end
  return configs[k]
end

return setmetatable(M, mt)
-- vim:et ts=2 sw=2
