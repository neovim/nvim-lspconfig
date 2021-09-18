require 'lspconfig'
local util = require 'lspconfig/util'
local configs = require 'lspconfig/configs'

local server_info = require 'lspconfig/util/server-info'

local updated_conf_dir = 'updated'
vim.fn.mkdir(updated_conf_dir, 'p')

local function gen_config_path(name)
  return updated_conf_dir .. '/' .. name .. '_new.lua'
end
--[[
local function dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
  return ...
end
dump(server_info.get_configuration_info 'https://github.com/bmewburn/vscode-intelephense')
local matches = server_info.get_all_servers_with_configuration_info()
dump(matches)
util.write_async('lspconfig/util/all-servers-with-info.lua', vim.inspect(matches))
--]]
--
-- Configs are lazy-loaded, tickle them to populate the `configs` singleton.
for _, v in ipairs(vim.fn.glob('lua/lspconfig/*.lua', 1, 1)) do
  local module_name = v:gsub('.*/', ''):gsub('%.lua$', '')
  require('lspconfig/' .. module_name)
end

local all_package_json_matches = server_info.get_all_servers_with_package_json()

local all_matches_names = {}
for _, s in ipairs(all_package_json_matches) do
  table.insert(all_matches_names, s.language)
end

local missing_configs = {}
local matching_configs = {}

for _, config in pairs(configs) do
  if config.document_config and config.document_config.docs then
    if not config.document_config.docs.package_json then
      -- TODO: this is missing a lot of servers currently
      local matching_server_info = server_info.get_server_info_by_config(config.document_config)
      if matching_server_info then
        table.insert(missing_configs, config.name)
        config.document_config.server_info = matching_server_info
        util.write_async(gen_config_path(config.name), vim.inspect(config))
      end
    else
      table.insert(matching_configs, config.name)
    end
  end
end

local info = { '[' .. #all_matches_names .. '] all found servers with package_json: ', '' }
vim.list_extend(info, all_matches_names)
vim.list_extend(info, { '', '[' .. #matching_configs .. '] configured servers with package_json: ', '' })
vim.list_extend(info, matching_configs)
vim.list_extend(info, { '', '[' .. #missing_configs .. '] was able to match servers with missing package_json: ', '' })
vim.list_extend(info, missing_configs)

local outfile = 'all_info.txt'
util.write_async(outfile, table.concat(info, '\n'))
