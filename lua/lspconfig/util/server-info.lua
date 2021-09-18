local M = {}

local servers = require 'lspconfig/util/servers'
local util = require 'lspconfig/util'

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
  local matches = {}
  for _, s in ipairs(servers) do
    if s[4] and s[4]:match '[T|t]ype[S|s]cript' then
      table.insert(matches, s)
    end
  end
  return matches
end

function M.get_package_json_from_docs(docs)
  if not docs.url then
    return
  end
  return M.get_package_json_from_url(docs.url)
end

function M.get_package_json_from_url(url)
  if not url or url == '' then
    return
  end
  if url:match 'github' then
    local gh_repo_name = url:gsub('https://github.com/', '')

    local cmd = string.format('gh api repos/%s/contents/package.json -q .download_url', gh_repo_name)
    local package_json = string.gsub(vim.fn.system(cmd), '%s+', '')
    -- TODO: only return true for ones with valid info(?)
    if not package_json:match '404' then
      return package_json
    end
  end
end

function M.get_all_servers_repos()
  local list = {}
  for _, s in ipairs(servers) do
    table.insert(list, s[3] or {})
  end
  return list
end

function M.get_all_servers_with_package_json()
  local status_ok, list = pcall(require, 'lspconfig/util/all-servers')
  if status_ok then
    return list
  end

  for _, s in ipairs(servers) do
    local entry = {
      language = s[1],
      maintainer = s[2] or '',
      url = s[3] or '',
      impl = s[4] or '',
      package_json = '',
    }
    if entry.url then
      entry.package_json = M.get_package_json_from_url(entry.url)
      if entry.package_json then
        table.insert(list, entry)
      end
    end
  end
  -- cache the searches
  util.write_async('lspconfig/util/all-servers.lua', vim.inspect(list))
  return list
end

function M.get_all_servers_with_configuration_info()
  local servers_list = M.get_all_servers_with_package_json()
  local matches = {}
  for _, s in ipairs(servers_list) do
    if M.get_configuration_info(s.url) then
      table.insert(matches, s)
    end
  end
  return matches
end

function M.get_configuration_info(url)
  local package_json_url = M.get_package_json_from_url(url)
  if not package_json_url or package_json_url == '' then
    return
  end

  local query = [['if has("contributes") then .contributes else .configuration end']]
  local cmd = string.format('curl -LSs %s | jq %s', package_json_url, query)
  local configuration = string.gsub(vim.fn.system(cmd), '%s+', '')
  if configuration then
    return configuration
  end
end

function M.get_server_info_by_config(c)
  local all_servers = require 'lspconfig/util/all-servers'
  if not c.default_config then
    return
  end
  local filetypes = c.default_config.filetypes or {}

  for _, server in pairs(all_servers) do
    if vim.tbl_contains(filetypes, string.lower(server.language)) then
      return server
    end
  end
end

return M
