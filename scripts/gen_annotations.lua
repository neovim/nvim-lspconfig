---Merge maps recursively and replace non-map values.
---@param ... any Values to merge in order.
---@return any
local function merge(...)
  ---Return whether a value can be merged as a map.
  ---@param value any Candidate value.
  ---@return boolean
  local function is_mergeable(value)
    return type(value) == 'table' and (vim.tbl_isempty(value) or not vim.islist(value))
  end

  local values = { ... }
  local merged = values[1]
  for i = 2, #values, 1 do
    local next_value = values[i]
    if is_mergeable(merged) and is_mergeable(next_value) then
      for key, item in pairs(next_value) do
        merged[key] = merge(merged[key], item)
      end
    else
      merged = next_value
    end
  end
  return merged
end

---@class Settings
---@field _settings table
---@field file string
local Settings = {}
Settings.__index = Settings

---Create a settings store from dotted keys.
---@param settings? table Initial dotted-key values.
---@return Settings
function Settings.new(settings)
  local self = setmetatable({ _settings = {} }, Settings)
  for key, value in pairs(settings or {}) do
    self:set(key, value)
  end
  return self
end

---Expand dotted keys in a table into nested tables.
---@param value any Source value.
---@return any
function Settings.expand_keys(value)
  if type(value) ~= 'table' then
    return value
  end
  local expanded = Settings.new()
  for key, item in pairs(value) do
    expanded:set(key, item)
  end
  return expanded:get()
end

---Split a dotted key into path segments.
---@param key any Dotted key or raw key value.
---@return any[]
function Settings.split_key(key)
  if not key or key == '' then
    return {}
  end
  if type(key) ~= 'string' then
    return { key }
  end
  local parts = {}
  for part in string.gmatch(key, '[^.]+') do
    table.insert(parts, part)
  end
  return parts
end

---Store a value at a dotted key path.
---@param key any Target dotted key.
---@param value any Value to store.
function Settings:set(key, value)
  local parts = Settings.split_key(key)

  if #parts == 0 then
    self._settings = value
    return
  end

  local node = self._settings
  for i = 1, #parts - 1, 1 do
    local part = parts[i]
    if type(node[part]) ~= 'table' then
      node[part] = {}
    end
    node = node[part]
  end
  node[parts[#parts]] = value
end

---Read a value from the settings store.
---@param key? any Dotted key to read.
---@param opts? {defaults?:table, expand?:boolean} Read options.
---@return any
function Settings:get(key, opts)
  ---@type table|nil
  local node = self._settings

  for _, part in ipairs(Settings.split_key(key)) do
    if type(node) ~= 'table' then
      node = nil
      break
    end
    node = node[part]
  end

  if opts and opts.expand and type(node) == 'table' then
    node = Settings.expand_keys(node)
  end

  if opts and opts.defaults then
    if node == nil then
      return vim.deepcopy(opts.defaults)
    end
    if type(node) ~= 'table' then
      return node
    end
    node = merge({}, opts.defaults, node)
  end

  return node
end

---Format schema text as Lua comments.
---@param desc? string Comment body.
---@param prefix? string Optional line prefix.
---@return string?
local function format_comment(desc, prefix)
  if desc then
    prefix = (prefix or '') .. '---'
    return prefix .. desc:gsub('\n', '\n' .. prefix)
  end
end

---Append a property's description comment.
---@param lines string[] Output buffer.
---@param prop table Schema property.
---@param prefix? string Optional line prefix.
local function append_description(lines, prop, prefix)
  local description = prop.markdownDescription or prop.description
  if type(description) == 'table' and description.message then
    description = description.message
  end
  if prop.default then
    if prop.default == vim.NIL then
      prop.default = nil
    end
    if type(prop.default) == 'table' and vim.tbl_isempty(prop.default) then
      prop.default = {}
    end
    description = (description and (description .. '\n\n') or '')
      .. '```lua\ndefault = '
      .. vim.inspect(prop.default)
      .. '\n```'
  end
  if description then
    table.insert(lines, format_comment(description, prefix))
  end
end

---Wrap nested schema nodes as object properties.
---@param node table Schema node tree.
---@return table
local function normalize_properties(node)
  return node.leaf and node
    or {
      type = 'object',
      properties = vim.tbl_map(function(child)
        return normalize_properties(child)
      end, node),
    }
end

---Normalize one schema path segment into a valid LuaLS class name segment.
---@param segment string
---@return string
local function segment_name_for_annotation(segment)
  local words = {}
  for word in string.gmatch(segment, '[%w]+') do
    if word:match('^%d') then
      word = '_' .. word
    end
    table.insert(words, word:sub(1, 1):upper() .. word:sub(2))
  end
  return #words > 0 and table.concat(words) or '_'
end

---Build the Lua class name for a schema node.
---@param path string[] Path segments from the schema root.
---@param root_class string Root class name.
---@return string
local function class_name_for(path, root_class)
  if #path == 0 then
    return root_class
  end
  local class_name = { '_', root_class }
  for _, segment in ipairs(path) do
    table.insert(class_name, segment_name_for_annotation(segment))
  end
  return table.concat(class_name, '.')
end

---@type table<string, true>
local lua_keywords = {
  ['and'] = true,
  ['break'] = true,
  ['do'] = true,
  ['else'] = true,
  ['elseif'] = true,
  ['end'] = true,
  ['false'] = true,
  ['for'] = true,
  ['function'] = true,
  ['goto'] = true,
  ['if'] = true,
  ['in'] = true,
  ['local'] = true,
  ['nil'] = true,
  ['not'] = true,
  ['or'] = true,
  ['package'] = true,
  ['repeat'] = true,
  ['return'] = true,
  ['then'] = true,
  ['true'] = true,
  ['until'] = true,
  ['while'] = true,
}

---Format a schema field name for use in a LuaLS `---@field` annotation.
---@param field string
---@return string
local function field_name_for_annotation(field)
  if field:match('^[A-Za-z_][A-Za-z0-9_]*$') and not lua_keywords[field] then
    return field
  end
  return '[' .. vim.inspect(field) .. ']'
end

---Convert a schema property into a Lua type.
---@param prop table Schema property.
---@return string
local function lua_type_for(prop)
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
        return lua_type_for(p)
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
          return 'any[]'
        end
        return (prop.items.type == 'object' and 'table' or prop.items.type) .. '[]'
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
  return table.concat(vim.iter(types):flatten():totable(), '|')
end

---Return whether a field is required by its parent schema.
---@param parent table
---@param field string
---@param child table
---@return boolean
local function is_required_field(parent, field, child)
  if child.required == true then
    return true
  end

  local required = parent.required
  if type(required) ~= 'table' then
    return false
  end

  for _, required_field in ipairs(required) do
    if required_field == field then
      return true
    end
  end

  return false
end

---Append annotations for an object node and its children.
---@param lines string[] Output buffer.
---@param path string[] Path segments from the schema root.
---@param prop table Object property schema.
---@param root_class string Root class name.
local function append_object(lines, path, prop, root_class)
  local object_lines = {}
  append_description(object_lines, prop)
  table.insert(object_lines, '---@class ' .. class_name_for(path, root_class))
  if prop.properties then
    local props = vim.tbl_keys(prop.properties)
    table.sort(props)
    for _, field in ipairs(props) do
      local child = prop.properties[field]
      local optional_marker = is_required_field(prop, field, child) and '' or '?'
      local field_name = field_name_for_annotation(field)
      append_description(object_lines, child)

      if child.type == 'object' and child.properties then
        local child_path = vim.deepcopy(path)
        table.insert(child_path, field)
        table.insert(
          object_lines,
          '---@field ' .. field_name .. optional_marker .. ' ' .. class_name_for(child_path, root_class)
        )
        append_object(lines, child_path, child, root_class)
      else
        table.insert(object_lines, '---@field ' .. field_name .. optional_marker .. ' ' .. lua_type_for(child))
      end
    end
  end
  table.insert(lines, '')
  vim.list_extend(lines, object_lines)
end

---Generate annotation lines for one schema file.
---@param file string Schema file path.
---@return string[]
local function generate_file_annotations(file)
  local name = vim.fn.fnamemodify(file, ':t:r')
  local json = vim.json.decode(vim.fn.readblob(file), { luanil = { array = true, object = true } }) or {}
  local class_name = 'lspconfig.settings.' .. name
  local lines = { '---@meta' }

  local schema = Settings.new()
  for key, prop in pairs(json.properties) do
    prop.leaf = true
    schema:set(key, prop)
  end

  append_object(lines, {}, normalize_properties(schema:get()), class_name)
  return vim.tbl_filter(function(v)
    return v ~= nil
  end, lines)
end

---Generate Lua annotation files from the schemas directory.
---@return nil
local function generate_all_annotations()
  local schema_dir = vim.fs.joinpath(vim.uv.cwd(), 'schemas')
  local output_dir = vim.fs.joinpath(vim.uv.cwd(), 'lua', 'lspconfig', 'types', 'lsp')

  vim.fn.delete(output_dir, 'rf')
  vim.fn.mkdir(output_dir, 'p')

  for name, type in vim.fs.dir(schema_dir) do
    if type == 'file' and vim.endswith(name, '.json') then
      local file = vim.fs.joinpath(schema_dir, name)
      local lines = generate_file_annotations(file)
      local output_file = vim.fs.joinpath(output_dir, vim.fn.fnamemodify(name, ':r') .. '.lua')
      vim.fn.writefile(vim.split(table.concat(lines, '\n') .. '\n', '\n', { plain = true }), output_file, 'b')
    end
  end
end

generate_all_annotations()
