if vim.g.lspconfig ~= nil then
  return
end
vim.g.lspconfig = 1

local complete_client = function(arg)
  return vim
    .iter(vim.lsp.get_clients())
    :map(function(client)
      return client.name
    end)
    :filter(function(name)
      return name:sub(1, #arg) == arg
    end)
    :totable()
end

local complete_config = function(arg)
  return vim
    .iter(vim.tbl_keys(vim.lsp._enabled_configs))
    :filter(function(name)
      return name:sub(1, #arg) == arg
    end)
    :totable()
end

-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
vim.api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', { desc = 'Alias to `:checkhealth vim.lsp`' })

vim.api.nvim_create_user_command('LspStart', function(info)
  local config = vim.lsp.config[info.args]
  local buffers_to_attach = {}

  if config == nil then
    vim.notify(("Invalid server name '%s'"):format(info.args))
    return
  end

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
    if vim.tbl_contains(config.filetypes, filetype) then
      buffers_to_attach[#buffers_to_attach + 1] = bufnr
    end
  end

  for _, bufnr in ipairs(buffers_to_attach) do
    if type(config.root_dir) == 'function' then
      ---@param root_dir string
      config.root_dir(bufnr, function(root_dir)
        config.root_dir = root_dir
        vim.schedule(function()
          vim.lsp.start(config, {
            bufnr = bufnr,
            reuse_client = config.reuse_client,
            _root_markers = config.root_markers,
          })
        end)
      end)
    else
      vim.lsp.start(config, {
        bufnr = bufnr,
        reuse_client = config.reuse_client,
        _root_markers = config.root_markers,
      })
    end
  end
end, {
  desc = 'Manually launches a language server',
  nargs = '?',
  complete = complete_config,
})

vim.api.nvim_create_user_command('LspRestart', function(info)
  local clients = vim
    .iter(info.fargs)
    :map(function(name)
      local client = vim.lsp.get_clients({ name = name })[1]
      if client == nil then
        vim.notify(("Invalid server name '%s'"):format(name))
      end
      return client
    end)
    :totable()

  local detach_clients = {}
  for _, client in ipairs(clients) do
    detach_clients[vim.lsp.config[client.name]] = vim.lsp.get_buffers_by_client_id(client.id)
    client:stop()
  end

  local timer = assert(vim.uv.new_timer())
  timer:start(
    500,
    0,
    vim.schedule_wrap(function()
      for config, buffers in pairs(detach_clients) do
        for _, bufnr in ipairs(buffers) do
          if type(config.root_dir) == 'function' then
            ---@param root_dir string
            config.root_dir(bufnr, function(root_dir)
              config.root_dir = root_dir
              vim.schedule(function()
                vim.lsp.start(config, {
                  bufnr = bufnr,
                  reuse_client = config.reuse_client,
                  _root_markers = config.root_markers,
                })
              end)
            end)
          else
            vim.lsp.start(config, {
              bufnr = bufnr,
              reuse_client = config.reuse_client,
              _root_markers = config.root_markers,
            })
          end
        end
      end
    end)
  )
end, {
  desc = 'Manually restart the given language client(s)',
  nargs = '*',
  complete = complete_client,
})

vim.api.nvim_create_user_command('LspStop', function(info)
  ---@type string
  local args = info.args
  local force = false
  args = args:gsub('%+%+force', function()
    force = true
    return ''
  end)

  local clients = {}

  -- default to stopping all servers on current buffer
  if #args == 0 then
    clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  else
    clients = vim
      .iter(vim.split(args, ' '))
      :map(function(name)
        local client = vim.lsp.get_clients({ name = name })[1]
        if client == nil then
          vim.notify(("Invalid server name '%s'"):format(name))
        end
        return client
      end)
      :totable()
  end

  for _, client in ipairs(clients) do
    client:stop(force)
  end
end, {
  desc = 'Manually stops the given language client(s)',
  nargs = '+',
  complete = complete_client,
})

vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd(string.format('tabnew %s', vim.lsp.get_log_path()))
end, {
  desc = 'Opens the Nvim LSP client log.',
})
