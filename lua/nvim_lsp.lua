local skeleton = require 'nvim_lsp/skeleton'
require 'nvim_lsp/clangd'
require 'nvim_lsp/elmls'
require 'nvim_lsp/gopls'
require 'nvim_lsp/pyls'
require 'nvim_lsp/texlab'
require 'nvim_lsp/tsserver'

local M = {
  util = require 'nvim_lsp/util';
}

local mt = {}
function mt:__index(k)
  return skeleton[k]
end

return setmetatable(M, mt)
-- vim:et ts=2 sw=2
