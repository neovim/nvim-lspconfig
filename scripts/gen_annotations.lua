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
    -- Lua also ends a comment at `\r`.
    return prefix .. desc:gsub('\r\n?', '\n'):gsub('\n', '\n' .. prefix)
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

---Build the Lua class name for a nested schema object.
---`lspconfig.settings.x` + `foo` => `_.lspconfig.settings.x.Foo`, then + `bar` => `_.lspconfig.settings.x.Foo.Bar`.
---@param class_name string Parent class name.
---@param field string
---@return string
local function child_class_name(class_name, field)
  local parent = vim.startswith(class_name, '_.') and class_name or ('_.%s'):format(class_name)
  return ('%s.%s'):format(parent, segment_name_for_annotation(field))
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

---LuaLS type of each JSON Schema `type`, except `array` (see lua_type_for). Others (`null`, invalid) are dropped.
---@type table<string, string>
local json_types = {
  boolean = 'boolean',
  integer = 'integer',
  number = 'number',
  object = 'table',
  string = 'string',
}

---Format a JSON value as a LuaLS literal type.
---@param value any
---@return string
local function literal_type_for(value)
  return type(value) == 'table' and 'table' or vim.inspect(value)
end

---Convert a schema property into a Lua type.
---@param prop any Schema property.
---@param refs table<string, string> Class name of each `$ref` target (see generate_file_annotations).
---@return string
local function lua_type_for(prop, refs)
  if type(prop) ~= 'table' then
    return 'any'
  end
  if prop['$ref'] then
    return refs[prop['$ref']] or 'any'
  end
  if prop.const ~= nil and type(prop.type) ~= 'table' then
    return literal_type_for(prop.const)
  end
  local types = {}
  if prop.enum then
    types = vim.tbl_map(literal_type_for, prop.enum)
  elseif prop.type then
    for _, t in ipairs(type(prop.type) == 'table' and prop.type or { prop.type }) do
      if t == 'array' then
        local item_type = lua_type_for(prop.items, refs)
        table.insert(types, (item_type:find('|', 1, true) and '(%s)[]' or '%s[]'):format(item_type))
      elseif json_types[t] then
        table.insert(types, json_types[t])
      end
    end
  else
    -- Convert `anyOf`/`oneOf` to a union, excluding null:
    -- `{ anyOf = { { type = 'string' }, { type = 'number' }, { type = 'null' } } }` => `string|number`.
    for _, alternative in ipairs(prop.anyOf or prop.oneOf or {}) do
      if type(alternative) ~= 'table' or alternative.type ~= 'null' then
        table.insert(types, lua_type_for(alternative, refs))
      end
    end
  end
  return #types > 0 and table.concat(vim.list.unique(types), '|') or 'any'
end

---Get the object schema (with `properties`) declared by `prop`, if any.
---`{ anyOf = { { type = 'object', properties = … }, { type = 'null' } } }` => the first alternative.
---@param prop any Schema property.
---@return table?
local function object_schema(prop)
  if type(prop) ~= 'table' then
    return nil
  end
  if prop.type == 'object' and prop.properties then
    return prop
  end
  local alternatives = vim.tbl_filter(function(alternative)
    return type(alternative) ~= 'table' or alternative.type ~= 'null'
  end, prop.anyOf or prop.oneOf or {})
  return #alternatives == 1 and object_schema(alternatives[1]) or nil
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
---@param class_name string
---@param prop table Object property schema.
---@param refs table<string, string> (see lua_type_for)
local function append_object(lines, class_name, prop, refs)
  local object_lines = {}
  append_description(object_lines, prop)
  table.insert(object_lines, ('---@class %s'):format(class_name))
  local fields = vim.tbl_keys(prop.properties or {})
  table.sort(fields)
  for _, field in ipairs(fields) do
    local child = type(prop.properties[field]) == 'table' and prop.properties[field] or {}
    local optional_marker = is_required_field(prop, field, child) and '' or '?'
    append_description(object_lines, child)

    local object = object_schema(child)
    local field_type = object and child_class_name(class_name, field) or lua_type_for(child, refs)
    table.insert(
      object_lines,
      ('---@field %s%s %s'):format(field_name_for_annotation(field), optional_marker, field_type)
    )
    if object then
      append_object(lines, field_type, object, refs)
    end
  end
  table.insert(lines, '')
  vim.list_extend(lines, object_lines)
end

---Append annotations for a schema definition.
---@param lines string[] Output buffer.
---@param class_name string
---@param def table Definition schema.
---@param refs table<string, string> (see lua_type_for)
local function append_definition(lines, class_name, def, refs)
  local object = object_schema(def)
  if object then
    append_object(lines, class_name, object, refs)
    return
  end
  table.insert(lines, '')
  append_description(lines, def)
  if not def.enum then
    table.insert(lines, ('---@alias %s %s'):format(class_name, lua_type_for(def, refs)))
    return
  end
  -- One member per line keeps diffs small for huge enums (e.g. ruff `RuleSelector`).
  table.insert(lines, ('---@alias %s'):format(class_name))
  for _, value in ipairs(def.enum) do
    table.insert(lines, ('---| %s'):format(literal_type_for(value)))
  end
end

---Generate annotation lines for one schema file.
---@param file string Schema file path.
---@return string[]
local function generate_file_annotations(file)
  local name = vim.fn.fnamemodify(file, ':t:r')
  local json = vim.json.decode(vim.fn.readblob(file), { luanil = { array = true, object = true } }) or {}
  local class_name = 'lspconfig.settings.' .. name
  local lines = { '---@meta' }

  -- `{ ['$ref'] = '#/$defs/Foo' }` => `_.lspconfig.settings.<name>.defs.Foo`, annotated once.
  local refs = {} ---@type table<string, string>
  local defs = {} ---@type table<string, table>
  for _, key in ipairs({ '$defs', 'definitions' }) do
    for def_name, def in pairs(json[key] or {}) do
      local def_class = ('_.%s.defs.%s'):format(class_name, segment_name_for_annotation(def_name))
      refs[('#/%s/%s'):format(key, def_name)] = def_class
      defs[def_class] = type(def) == 'table' and def or {}
    end
  end
  for def_class, def in vim.spairs(defs) do
    append_definition(lines, def_class, def, refs)
  end

  local schema = Settings.new()
  for key, prop in pairs(json.properties) do
    prop = type(prop) == 'table' and prop or {}
    prop.leaf = true
    schema:set(key, prop)
  end

  append_object(lines, class_name, normalize_properties(schema:get()), refs)
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
