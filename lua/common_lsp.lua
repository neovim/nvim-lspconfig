local skeleton = require 'common_lsp/skeleton'
require 'common_lsp/gopls'
require 'common_lsp/texlab'

local M = {
  util = require 'common_lsp/util';
}

local mt = {}
function mt:__index(k)
  return skeleton[k]
end

return setmetatable(M, mt)
-- vim:et ts=2 sw=2
