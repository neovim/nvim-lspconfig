local M = {}

local servers = require 'lspconfig/servers'

local lang = 1
local maintainer = 2
local repo = 3
local impl = 4

local format = function(entry)
  if entry[lang] then
    -- extract title
    entry[lang] = entry[lang]:match '%[(%w.*)%]' or entry[lang]
  end
  if entry[maintainer] then
    entry[maintainer] = entry[maintainer]:match 'https.*%w' or entry[maintainer]
  end
  if entry[repo] then
    -- extract URL
    entry[repo] = entry[repo]:match 'https.*%w' or entry[repo]
  end
  if entry[impl] then
    -- extract title
    entry[impl] = entry[impl]:match '%[(%w.*)%]' or entry[impl]
  end
end

vim.tbl_map(format, servers)

function M.get_server_info_by_lang(name)
  return vim.tbl_filter(function(entry)
    return entry[lang] == name
  end, servers)
end
function M.get_server_info_by_impl(name)
  return vim.tbl_filter(function(entry)
    return entry[impl] == name
  end, servers)
end

function M.get_ts_implemented_servers()
  package.loaded['servers'] = nil
  local matches = {}
  for _, s in ipairs(servers) do
    if s[4] and s[4]:match '[T|t]ype[S|s]cript' then
      table.insert(matches, s)
    end
  end
  return matches
end

return M
