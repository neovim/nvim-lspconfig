local skeleton = require 'nvim_lsp/skeleton'
require 'nvim_lsp/gopls'
require 'nvim_lsp/texlab'
require 'nvim_lsp/clangd'

local M = {
  util = require 'nvim_lsp/util';
}

local mt = {}
function mt:__index(k)
  return skeleton[k]
end

return setmetatable(M, mt)
-- vim:et ts=2 sw=2
