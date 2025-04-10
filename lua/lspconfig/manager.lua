local api = vim.api
local lsp = vim.lsp

local async = require 'lspconfig.async'
local util = require 'lspconfig.util'

---@param client vim.lsp.Client
---@param root_dir string
---@return boolean
local function is_dir_in_workspace_folders(client, root_dir)
  if not client.workspace_folders then
    return false
  end

  for _, dir in ipairs(client.workspace_folders) do
    if (root_dir .. '/'):sub(1, #dir.name + 1) == dir.name .. '/' then
      return true
    end
  end

  return false
end

--- @class lspconfig.Manager
--- @field _clients table<string,table<string, vim.lsp.Client>> root dir -> (client name -> client)
--- @field config lspconfig.Config
--- @field make_config fun(root_dir: string): lspconfig.Config
local M = {}

--- @param config lspconfig.Config
--- @param make_config fun(root_dir: string): lspconfig.Config
--- @return lspconfig.Manager
function M.new(config, make_config)
  return setmetatable({
    _clients = {},
    config = config,
    make_config = make_config,
  }, {
    __index = M,
  })
end

--- @private
--- @param root string
--- @param client vim.lsp.Client
function M:_cache_client(root, client)
  local clients = self._clients
  if not clients[root] then
    clients[root] = {}
  end
  if not clients[root][client.name] then
    clients[root][client.name] = client
  end
end

--- @private
--- @param root_dir string
--- @param client vim.lsp.Client
function M:_notify_workspace_folder_added(root_dir, client)
  if is_dir_in_workspace_folders(client, root_dir) then
    return
  end

  local supported = vim.tbl_get(client, 'server_capabilities', 'workspace', 'workspaceFolders', 'supported')
  if not supported then
    return
  end

  local params = {
    event = {
      added = { { uri = vim.uri_from_fname(root_dir), name = root_dir } },
      removed = {},
    },
  }
  client.rpc.notify('workspace/didChangeWorkspaceFolders', params)
  if not client.workspace_folders then
    client.workspace_folders = {}
  end
  client.workspace_folders[#client.workspace_folders + 1] = params.event.added[1]
end

--- @private
--- @param bufnr integer
--- @param new_config lspconfig.Config
--- @param root_dir string
--- @param single_file boolean
--- @param silent boolean
function M:_start_client(bufnr, new_config, root_dir, single_file, silent)
  -- do nothing if the client is not enabled
  if new_config.enabled == false then
    return
  end
  if not new_config.cmd then
    vim.notify(
      string.format(
        '[lspconfig] cmd not defined for %q. Manually set cmd in the setup {} call according to configs.md, see :help lspconfig-setup.',
        new_config.name
      ),
      vim.log.levels.ERROR
    )
    return
  end

  new_config.on_init = util.add_hook_before(new_config.on_init, function(client)
    self:_notify_workspace_folder_added(root_dir, client)
  end)

  new_config.on_exit = util.add_hook_before(new_config.on_exit, function()
    for name in pairs(self._clients[root_dir]) do
      if name == new_config.name then
        self._clients[root_dir][name] = nil
      end
    end
  end)

  -- Launch the server in the root directory used internally by lspconfig, if otherwise unset
  -- also check that the path exist
  if not new_config.cmd_cwd and vim.uv.fs_realpath(root_dir) then
    new_config.cmd_cwd = root_dir
  end

  -- Sending rootDirectory and workspaceFolders as null is not explicitly
  -- codified in the spec. Certain servers crash if initialized with a NULL
  -- root directory.
  if single_file then
    new_config.root_dir = nil
    new_config.workspace_folders = nil
  end

  local client_id = lsp.start(new_config, {
    bufnr = bufnr,
    silent = silent,
    reuse_client = function(existing_client)
      if (self._clients[root_dir] or {})[existing_client.name] then
        self:_notify_workspace_folder_added(root_dir, existing_client)
        return true
      end

      for _, dir_clients in pairs(self._clients) do
        if dir_clients[existing_client.name] then
          self:_notify_workspace_folder_added(root_dir, existing_client)
          return true
        end
      end

      return false
    end,
  })
  if client_id then
    self:_cache_client(root_dir, assert(lsp.get_client_by_id(client_id)))
  end
end

---@param root_dir string
---@param single_file boolean
---@param bufnr integer
---@param silent boolean
function M:add(root_dir, single_file, bufnr, silent)
  root_dir = vim.fs.normalize(root_dir)
  local new_config = self.make_config(root_dir)
  self:_start_client(bufnr, new_config, root_dir, single_file, silent)
end

--- @return vim.lsp.Client[]
function M:clients()
  local res = {}
  for _, dir_clients in pairs(self._clients) do
    for _, client in pairs(dir_clients) do
      res[#res + 1] = client
    end
  end
  return res
end

--- Try to attach the buffer `bufnr` to a client using this config, creating
--- a new client if one doesn't already exist for `bufnr`.
--- @param bufnr integer
--- @param project_root? string
--- @param silent boolean
function M:try_add(bufnr, project_root, silent)
  bufnr = bufnr or api.nvim_get_current_buf()

  if vim.bo[bufnr].buftype == 'nofile' then
    return
  end

  local bufname = api.nvim_buf_get_name(bufnr)
  if #bufname == 0 and not self.config.single_file_support then
    return
  end

  if #bufname ~= 0 and not util.bufname_valid(bufname) then
    return
  end

  if project_root then
    self:add(project_root, false, bufnr, silent)
    return
  end

  local buf_path = vim.fs.normalize(bufname)

  local get_root_dir = self.config.root_dir

  local pwd = assert(vim.uv.cwd())

  async.run(function()
    local root_dir
    if type(get_root_dir) == 'function' then
      root_dir = get_root_dir(buf_path, bufnr)
      async.reenter()
      if not api.nvim_buf_is_valid(bufnr) then
        return
      end
    elseif type(get_root_dir) == 'string' then
      root_dir = get_root_dir
    end

    if root_dir then
      self:add(root_dir, false, bufnr, silent)
    elseif self.config.single_file_support then
      local pseudo_root = #bufname == 0 and pwd or vim.fs.dirname(buf_path)
      self:add(pseudo_root, true, bufnr, silent)
    end
  end)
end

--- Check that the buffer `bufnr` has a valid filetype according to
--- `config.filetypes`, then do `manager.try_add(bufnr)`.
--- @param bufnr integer
--- @param project_root? string
function M:try_add_wrapper(bufnr, project_root)
  local config = self.config
  -- `config.filetypes = nil` means all filetypes are valid.
  if not config.filetypes or vim.tbl_contains(config.filetypes, vim.bo[bufnr].filetype) then
    self:try_add(bufnr, project_root, config.silent)
  end
end

return M
