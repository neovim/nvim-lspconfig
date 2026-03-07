local util = require('scripts.gen_types.util')

local M = {}

M.class_name = ''
M.lines = {}

function M.table_key(str)
  if str:match('[^%a_]') then
    return '[' .. vim.inspect(str) .. ']'
  end
  return str
end

function M.comment(desc, prefix)
  if desc then
    prefix = (prefix or '') .. '-- '
    return prefix .. desc:gsub('\n', '\n' .. prefix)
  end
end

function M.add_desc(lines, prop, prefix)
  local ret = prop.markdownDescription or prop.description
  if type(ret) == 'table' and ret.message then
    ret = ret.message
  end
  if prop.default then
    if prop.default == vim.NIL then
      prop.default = nil
    end
    if type(prop.default) == 'table' and vim.tbl_isempty(prop.default) then
      prop.default = {}
    end
    ret = (ret and (ret .. '\n\n') or '') .. '```lua\ndefault = ' .. vim.inspect(prop.default) .. '\n```'
  end
  if ret then
    table.insert(lines, M.comment(ret, prefix))
  end
end

function M.fix_props(node)
  return node.leaf and node
    or {
      type = 'object',
      properties = vim.tbl_map(function(child)
        return M.fix_props(child)
      end, node),
    }
end

function M.get_class(name)
  if name == M.class_name then
    return name
  end
  local ret = { '_', M.class_name }
  for word in string.gmatch(name, '([^_]+)') do
    table.insert(ret, word:sub(1, 1):upper() .. word:sub(2))
  end
  return table.concat(ret, '.')
end

function M.get_type(prop)
  if prop.enum then
    return table.concat(
      vim.tbl_map(function(e)
        return vim.inspect(e)
      end, prop.enum),
      ' | '
    )
  end
  local types = type(prop.type) == 'table' and prop.type or { prop.type }
  if vim.tbl_isempty(types) and type(prop.anyOf) == 'table' then
    return table.concat(
      vim.tbl_map(function(p)
        return M.get_type(p)
      end, prop.anyOf),
      '|'
    )
  end
  types = vim.tbl_map(function(t)
    if t == 'null' then
      return
    end
    if t == 'array' then
      if prop.items and prop.items.type then
        if type(prop.items.type) == 'table' then
          prop.items.type = 'any'
        end
        return prop.items.type .. '[]'
      end
      return 'any[]'
    end
    if t == 'object' then
      return 'table'
    end
    return t
  end, types)
  if vim.tbl_isempty(types) then
    types = { 'any' }
  end
  return table.concat(util.flatten(types), '|')
end

function M.process_object(name, prop)
  local lines = {}
  M.add_desc(lines, prop)
  table.insert(lines, '---@class ' .. M.get_class(name))
  if prop.properties then
    local props = vim.tbl_keys(prop.properties)
    table.sort(props)
    for _, field in ipairs(props) do
      local child = prop.properties[field]
      M.add_desc(lines, child)

      if child.type == 'object' and child.properties then
        table.insert(lines, '---@field ' .. field .. ' ' .. M.get_class(field))
        M.process_object(field, child)
      else
        table.insert(lines, '---@field ' .. field .. ' ' .. M.get_type(child))
      end
    end
  end
  table.insert(M.lines, '')
  vim.list_extend(M.lines, lines)
end

function M.process_prop(lines, name, prop)
  if prop.type == 'object' then
    error('should not happen')
  end

  table.insert(lines, '  ' .. M.table_key(name) .. ' = ' .. vim.inspect(prop.default) .. ',')
end

function M.build_annotations(name)
  local file = util.path('schemas/' .. name .. '.json')
  local json = util.json_decode(util.read_file(file)) or {}
  M.class_name = 'lspconfig.settings.' .. name

  local schema = require('neoconf.settings').new()
  for key, prop in pairs(json.properties) do
    prop.leaf = true
    schema:set(key, prop)
  end

  M.process_object(M.class_name, M.fix_props(schema:get()))
end

function M.build_lspconfig()
  local str = [[---@meta

---@class _.lspconfig.options
---@field root_dir fun(filename, bufnr): string|nil
---@field name string
---@field filetypes string[] | nil
---@field autostart boolean
---@field single_file_support boolean
---@field on_new_config fun(new_config, new_root_dir)
---@field capabilities table
---@field cmd string[]
---@field handlers table<string, fun()>
---@field init_options table
---@field on_attach fun(client, bufnr)

---@module 'lspconfig'
local lspconfig

]]

  local index = vim.tbl_keys(require('neoconf.build.schemas').get_schemas())
  table.sort(index)

  for _, name in ipairs(index) do
    str = str
      .. ([[

---@class lspconfig.options.%s: _.lspconfig.options
---@field settings lspconfig.settings.%s

lspconfig.%s = {
  ---@param options lspconfig.options.%s
  setup = function(options) end,
}
]]):format(name, name, name, name)
  end

  str = str .. '\n---@class lspconfig.options\n'
  for _, name in ipairs(index) do
    str = str .. ('---@field %s lspconfig.options.%s\n'):format(name, name)
  end

  str = str .. '\n---@class lspconfig.settings\n'
  for _, name, _ in ipairs(index) do
    str = str .. ('---@field %s lspconfig.settings.%s\n'):format(name, name)
  end

  str = str .. '\n\n return lspconfig'
  util.write_file('types/lua/lspconfig.lua', str)
end

function M.build()
  M.lines = { '---@meta\n' }
  local index = vim.tbl_keys(require('schemas').get_schemas())
  table.sort(index)
  for _, name in ipairs(index) do
    local ok, err = pcall(M.build_annotations, name)
    if not ok then
      print('error building ' .. name .. ': ' .. err)
    end
  end

  local lines = vim.tbl_filter(function(v)
    return v ~= nil
  end, M.lines)
  util.write_file('types/lsp.lua', table.concat(lines, '\n'))
  M.build_lspconfig()
end

return M
