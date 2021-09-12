require 'lspconfig'
local configs = require 'lspconfig/configs'
local server_info = require 'server-info'

local function dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
  return ...
end

local function require_all_configs()
  -- Configs are lazy-loaded, tickle them to populate the `configs` singleton.
  for _, v in ipairs(vim.fn.glob('lua/lspconfig/*.lua', 1, 1)) do
    local module_name = v:gsub('.*/', ''):gsub('%.lua$', '')
    require('lspconfig/' .. module_name)
  end
end

local function get_configs_with_package_json()
  require_all_configs()
  local matching_configs = {}

  for _, c in pairs(configs) do
    if c.document_config and c.document_config.docs and c.document_config.docs.package_json then
      table.insert(matching_configs, c.document_config.docs.package_json)
      -- dump(c.document_config.docs.package_json)
    end
  end
  dump(string.format('got [%s] configured package.json', #matching_configs))
  return matching_configs
end

local function get_missing_configs(t)
  local missing_configs = {}

  local ts_matches = server_info.get_ts_implemented_servers()
  if vim.tbl_isempty(ts_matches) then
    error 'unable to fetch table'
  end

  for _, server in pairs(ts_matches) do
    local repo_url = server[3]
    if repo_url:match 'github' then
      local gh_repo_name = repo_url:gsub('https://github.com/', '')

      local cmd = string.format('gh api repos/%s/contents/package.json -q .download_url', gh_repo_name)
      local package_json = string.gsub(vim.fn.system(cmd), '%s+', '')
      if not vim.tbl_contains(t, package_json) and not package_json:match '404' then
        table.insert(missing_configs, package_json)
      end
    end
  end

  dump(string.format('got [%s] missing matches!', #missing_configs))
  return missing_configs
end

local configs_table = get_configs_with_package_json()

local matches = get_missing_configs(configs_table)
-- vim.tbl_map(function(c)
--   dump(string.format('found a missing server config, for [%s]', c))
-- end, matches)

local writer = io.open('missing_matches.txt', 'w')
writer:write(table.concat(matches, '\n'))
writer:close()
