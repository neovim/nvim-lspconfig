local M = {}

---@param t table
---@param ret? table
function M.flatten(t, ret)
  ret = ret or {}
  for _, v in pairs(t) do
    if type(v) == 'table' then
      M.flatten(v, ret)
    else
      ret[#ret + 1] = v
    end
  end
  return ret
end

function M.path(str)
  local f = debug.getinfo(1, 'S').source:sub(2)
  return M.fqn(vim.fn.fnamemodify(f, ':h:h:h') .. '/' .. (str or ''))
end

function M.read_file(file)
  local fd = io.open(file, 'r')
  if not fd then
    error(('Could not open file %s for reading'):format(file))
  end
  local data = fd:read('*a')
  fd:close()
  return data
end

function M.write_file(file, data)
  local fd = io.open(file, 'w+')
  if not fd then
    error(('Could not open file %s for writing'):format(file))
  end
  fd:write(data)
  fd:close()
end

function M.json_decode(json)
  json = vim.trim(json)
  if json == '' then
    json = '{}'
  end
  return require('scripts.gen_types').decode_jsonc(json)
end

function M.fqn(fname)
  fname = vim.fn.fnamemodify(fname, ':p')
  return uv.fs_realpath(fname) or fname
end

function M.fetch(url)
  local fd = io.popen(string.format('curl -s -k %q', url))
  if not fd then
    error(('Could not download %s'):format(url))
  end
  local ret = fd:read('*a')
  fd:close()
  return ret
end

function M.json_format(obj)
  local tmp = os.tmpname()
  M.write_file(tmp, vim.json.encode(obj))
  local fd = io.popen('jq -S < ' .. tmp)
  if not fd then
    error('Could not format json')
  end
  local ret = fd:read('*a')
  if ret == '' then
    error('Could not format json')
  end
  fd:close()
  return ret
end

function M.exists(fname)
  local stat = vim.uv.fs_stat(fname)
  return (stat and stat.type) or false
end

return M
