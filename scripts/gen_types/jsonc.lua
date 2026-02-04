local type = type
local next = next
local error = error
local tonumber = tonumber
local string_char = string.char
local string_byte = string.byte
local string_find = string.find
local string_match = string.match
local string_gsub = string.gsub
local string_sub = string.sub
local string_format = string.format

local utf8_char

local math_floor = math.floor
function utf8_char(c)
  if c <= 0x7f then
    return string_char(c)
  elseif c <= 0x7ff then
    return string_char(math_floor(c / 64) + 192, c % 64 + 128)
  elseif c <= 0xffff then
    return string_char(math_floor(c / 4096) + 224, math_floor(c % 4096 / 64) + 128, c % 64 + 128)
  elseif c <= 0x10ffff then
    return string_char(
      math_floor(c / 262144) + 240,
      math_floor(c % 262144 / 4096) + 128,
      math_floor(c % 4096 / 64) + 128,
      c % 64 + 128
    )
  end
  error(string_format("invalid UTF-8 code '%x'", c))
end

local json = require('neoconf.json')

local encode_escape_map = {
  ['"'] = '\\"',
  ['\\'] = '\\\\',
  ['/'] = '\\/',
  ['\b'] = '\\b',
  ['\f'] = '\\f',
  ['\n'] = '\\n',
  ['\r'] = '\\r',
  ['\t'] = '\\t',
}

local decode_escape_set = {}
local decode_escape_map = {}
for k, v in next, encode_escape_map do
  decode_escape_map[v] = k
  decode_escape_set[string_byte(v, 2)] = true
end

local statusBuf
local statusPos
local statusTop
local statusAry = {}
local statusRef = {}

local function find_line()
  local line = 1
  local pos = 1
  while true do
    local f, _, nl1, nl2 = string_find(statusBuf, '([\n\r])([\n\r]?)', pos)
    if not f then
      return line, statusPos - pos + 1
    end
    local newpos = f + ((nl1 == nl2 or nl2 == '') and 1 or 2)
    if newpos > statusPos then
      return line, statusPos - pos + 1
    end
    pos = newpos
    line = line + 1
  end
end

local function decode_error(msg)
  error(string_format('ERROR: %s at line %d col %d', msg, find_line()), 2)
end

local function get_word()
  return string_match(statusBuf, '^[^ \t\r\n%]},]*', statusPos)
end

local function skip_comment(b)
  if
    b ~= 47 --[[ '/' ]]
  then
    return
  end
  local c = string_byte(statusBuf, statusPos + 1)
  if
    c == 42 --[[ '*' ]]
  then
    -- block comment
    local pos = string_find(statusBuf, '*/', statusPos)
    if pos then
      statusPos = pos + 2
    else
      statusPos = #statusBuf + 1
    end
    return true
  elseif
    c == 47 --[[ '/' ]]
  then
    -- line comment
    local pos = string_find(statusBuf, '[\r\n]', statusPos)
    if pos then
      statusPos = pos
    else
      statusPos = #statusBuf + 1
    end
    return true
  end
end

local function next_byte()
  local pos = string_find(statusBuf, '[^ \t\r\n]', statusPos)
  if pos then
    statusPos = pos
    local b = string_byte(statusBuf, pos)
    if not skip_comment(b) then
      return b
    end
    return next_byte()
  end
  return -1
end

local function decode_unicode_surrogate(s1, s2)
  return utf8_char(0x10000 + (tonumber(s1, 16) - 0xd800) * 0x400 + (tonumber(s2, 16) - 0xdc00))
end

local function decode_unicode_escape(s)
  return utf8_char(tonumber(s, 16))
end

local function decode_string()
  local has_unicode_escape = false
  local has_escape = false
  local i = statusPos + 1
  while true do
    i = string_find(statusBuf, '[%z\1-\31\\"]', i)
    if not i then
      decode_error('expected closing quote for string')
    end
    local x = string_byte(statusBuf, i)
    if x < 32 then
      statusPos = i
      decode_error('control character in string')
    end
    if
      x == 34 --[[ '"' ]]
    then
      local s = string_sub(statusBuf, statusPos + 1, i - 1)
      if has_unicode_escape then
        s = string_gsub(
          string_gsub(s, '\\u([dD][89aAbB]%x%x)\\u([dD][c-fC-F]%x%x)', decode_unicode_surrogate),
          '\\u(%x%x%x%x)',
          decode_unicode_escape
        )
      end
      if has_escape then
        s = string_gsub(s, '\\.', decode_escape_map)
      end
      statusPos = i + 1
      return s
    end
    --assert(x == 92 --[[ "\\" ]])
    local nx = string_byte(statusBuf, i + 1)
    if
      nx == 117 --[[ "u" ]]
    then
      if not string_match(statusBuf, '^%x%x%x%x', i + 2) then
        statusPos = i
        decode_error('invalid unicode escape in string')
      end
      has_unicode_escape = true
      i = i + 6
    else
      if not decode_escape_set[nx] then
        statusPos = i
        decode_error("invalid escape char '" .. (nx and string_char(nx) or '<eol>') .. "' in string")
      end
      has_escape = true
      i = i + 2
    end
  end
end

local function decode_number()
  local num, c = string_match(statusBuf, '^([0-9]+%.?[0-9]*)([eE]?)', statusPos)
  if
    not num or string_byte(num, -1) == 0x2E --[[ "." ]]
  then
    decode_error("invalid number '" .. get_word() .. "'")
  end
  if c ~= '' then
    num = string_match(statusBuf, '^([^eE]*[eE][-+]?[0-9]+)[ \t\r\n%]},/]', statusPos)
    if not num then
      decode_error("invalid number '" .. get_word() .. "'")
    end
  end
  statusPos = statusPos + #num
  return tonumber(num)
end

local function decode_number_zero()
  local num, c = string_match(statusBuf, '^(.%.?[0-9]*)([eE]?)', statusPos)
  if
    not num
    or string_byte(num, -1) == 0x2E --[[ "." ]]
    or string_match(statusBuf, '^.[0-9]+', statusPos)
  then
    decode_error("invalid number '" .. get_word() .. "'")
  end
  if c ~= '' then
    num = string_match(statusBuf, '^([^eE]*[eE][-+]?[0-9]+)[ \t\r\n%]},/]', statusPos)
    if not num then
      decode_error("invalid number '" .. get_word() .. "'")
    end
  end
  statusPos = statusPos + #num
  return tonumber(num)
end

local function decode_number_negative()
  statusPos = statusPos + 1
  local c = string_byte(statusBuf, statusPos)
  if c then
    if c == 0x30 then
      return -decode_number_zero()
    elseif c > 0x30 and c < 0x3A then
      return -decode_number()
    end
  end
  decode_error("invalid number '" .. get_word() .. "'")
end

local function decode_true()
  if string_sub(statusBuf, statusPos, statusPos + 3) ~= 'true' then
    decode_error("invalid literal '" .. get_word() .. "'")
  end
  statusPos = statusPos + 4
  return true
end

local function decode_false()
  if string_sub(statusBuf, statusPos, statusPos + 4) ~= 'false' then
    decode_error("invalid literal '" .. get_word() .. "'")
  end
  statusPos = statusPos + 5
  return false
end

local function decode_null()
  if string_sub(statusBuf, statusPos, statusPos + 3) ~= 'null' then
    decode_error("invalid literal '" .. get_word() .. "'")
  end
  statusPos = statusPos + 4
  return json.null
end

local function decode_array()
  statusPos = statusPos + 1
  local res = {}
  local chr = next_byte()
  if
    chr == 93 --[[ ']' ]]
  then
    statusPos = statusPos + 1
    return res
  end
  statusTop = statusTop + 1
  statusAry[statusTop] = true
  statusRef[statusTop] = res
  return res
end

local function decode_object()
  statusPos = statusPos + 1
  local res = {}
  local chr = next_byte()
  if
    chr == 125 --[[ ']' ]]
  then
    statusPos = statusPos + 1
    return json.createEmptyObject()
  end
  statusTop = statusTop + 1
  statusAry[statusTop] = false
  statusRef[statusTop] = res
  return res
end

local decode_uncompleted_map = {
  [string_byte('"')] = decode_string,
  [string_byte('0')] = decode_number_zero,
  [string_byte('1')] = decode_number,
  [string_byte('2')] = decode_number,
  [string_byte('3')] = decode_number,
  [string_byte('4')] = decode_number,
  [string_byte('5')] = decode_number,
  [string_byte('6')] = decode_number,
  [string_byte('7')] = decode_number,
  [string_byte('8')] = decode_number,
  [string_byte('9')] = decode_number,
  [string_byte('-')] = decode_number_negative,
  [string_byte('t')] = decode_true,
  [string_byte('f')] = decode_false,
  [string_byte('n')] = decode_null,
  [string_byte('[')] = decode_array,
  [string_byte('{')] = decode_object,
}
local function unexpected_character()
  decode_error("unexpected character '" .. string_sub(statusBuf, statusPos, statusPos) .. "'")
end
local function unexpected_eol()
  decode_error("unexpected character '<eol>'")
end

local decode_map = {}
for i = 0, 255 do
  decode_map[i] = decode_uncompleted_map[i] or unexpected_character
end
decode_map[-1] = unexpected_eol

local function decode()
  return decode_map[next_byte()]()
end

local function decode_item()
  local top = statusTop
  local ref = statusRef[top]
  if statusAry[top] then
    ref[#ref + 1] = decode()
  else
    local key = decode_string()
    if
      next_byte() ~= 58 --[[ ':' ]]
    then
      decode_error("expected ':'")
    end
    statusPos = statusPos + 1
    ref[key] = decode()
  end
  if top == statusTop then
    repeat
      local chr = next_byte()
      statusPos = statusPos + 1
      if
        chr == 44 --[[ "," ]]
      then
        local c = next_byte()
        if statusAry[statusTop] then
          if
            c ~= 93 --[[ "]" ]]
          then
            return
          end
        else
          if
            c ~= 125 --[[ "}" ]]
          then
            return
          end
        end
        statusPos = statusPos + 1
      else
        if statusAry[statusTop] then
          if
            chr ~= 93 --[[ "]" ]]
          then
            decode_error("expected ']' or ','")
          end
        else
          if
            chr ~= 125 --[[ "}" ]]
          then
            decode_error("expected '}' or ','")
          end
        end
      end
      statusTop = statusTop - 1
    until statusTop == 0
  end
end

function json.decode_jsonc(str)
  if type(str) ~= 'string' then
    error('expected argument of type string, got ' .. type(str))
  end
  statusBuf = str
  statusPos = 1
  statusTop = 0
  if next_byte() == -1 then
    return json.null
  end
  local res = decode()
  while statusTop > 0 do
    decode_item()
  end
  if string_find(statusBuf, '[^ \t\r\n]', statusPos) then
    decode_error('trailing garbage')
  end
  return res
end

return json
