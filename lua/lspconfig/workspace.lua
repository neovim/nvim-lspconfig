local wk = {}

local function box()
  local tbl = {}
  tbl.__index = tbl
  function tbl.__newindex(t, k, v)
    rawset(t, k, v)
  end

  function tbl:list()
    local res = {}
    for _, item in ipairs(self) do
      res[#res + 1] = item
    end
    return res
  end

  function tbl:append(tuple)
    if not vim.tbl_contains(self, tuple) then
      self[#self + 1] = tuple
    end
  end

  function tbl:get(root_name)
    for _, tuple in ipairs(self) do
      if tuple[1] == root_name then
        return tuple
      end
    end
  end

  function tbl:remove(name)
    for idx, item in ipairs(self) do
      if name == item then
        table.remove(self, idx)
        break
      end
    end
  end

  return tbl
end

function wk:create(name)
  if self[name] then
    vim.notify(string.format('[lspconfig] workspace %s already exist', name), vim.log.levels.WARN)
    return
  end
  self[name] = setmetatable({}, box())
  rawset(wk, 'current', name)
end

function wk:new()
  local o = {}
  o.default = setmetatable({}, box())
  setmetatable(o, self)
  self.__index = self
  self.current = 'default'
  return o
end

function wk:change(name)
  if not self[name] then
    self:create(name)
  end
  rawset(wk, 'current', name)
end

function wk:remove(name)
  self[name] = nil
end

function wk:all_list()
  local res = {}
  for k, v in pairs(self) do
    res[k] = {}
    for _, item in ipairs(v) do
      table.insert(res[k], item)
    end
  end
  print(vim.inspect(res))
end

function wk:find_space_by_client(client_id)
  for space, data in pairs(self) do
    for _, tuple in ipairs(data) do
      if vim.tbl_contains(tuple, client_id) then
        return space
      end
    end
  end
end

function wk:get_all_clients()
  local res = {}
  for _, data in pairs(self) do
    vim.tbl_map(function(tuple)
      for i = 2, #tuple do
        res[#res + 1] = vim.lsp.get_client_by_id(tuple[i])
      end
    end, data)
  end
  return res
end

local function workspace_init()
  local instance = wk:new()
  instance:change 'default'
  return instance
end

return {
  workspace_init = workspace_init,
}
