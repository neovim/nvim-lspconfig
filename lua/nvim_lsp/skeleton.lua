local util = require 'nvim_lsp/util'
local api, validate, lsp = vim.api, vim.validate, vim.lsp
local tbl_extend = vim.tbl_extend

local skeleton = {}


function skeleton.__newindex(t, template_name, template)
  validate {
    name = {template_name, 's'};
    default_config = {template.default_config, 't'};
    on_new_config = {template.on_new_config, 'f', true};
    on_attach = {template.on_attach, 'f', true};
    commands = {template.commands, 't', true};
  }
  if template.commands then
    for k, v in pairs(template.commands) do
      validate {
        ['command.name'] = {k, 's'};
        ['command.fn'] = {v[1], 'f'};
      }
    end
  end

  local M = {}

  local default_config = tbl_extend("keep", template.default_config, {
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
    callbacks = {};
  })

  -- Force this part.
  default_config.name = template_name

  -- The config here is the one which will be instantiated for the new server,
  -- which is why this is a function, so that it can refer to the settings
  -- object on the server.
  local function add_callbacks(config)
    config.callbacks["window/logMessage"] = function(err, method, params, client_id)
      if params and params.type <= config.log_level then
        -- TODO(ashkan) remove this after things have settled.
        assert(lsp.callbacks, "Please update neovim master. This is an incompatible interface.")
        lsp.callbacks[method](err, method, params, client_id)
      end
    end

    config.callbacks["workspace/configuration"] = function(err, method, params, client_id)
      if err then error(tostring(err)) end
      if not params.items then
        return {}
      end

      local result = {}
      for _, item in ipairs(params.items) do
        if item.section then
          local value = util.lookup_section(config.settings, item.section) or vim.NIL
          table.insert(result, value)
        end
      end
      return result
    end
  end

  function M.setup(config)
    validate {
      root_dir = {config.root_dir, 'f', default_config.root_dir ~= nil};
      filetypes = {config.filetype, 't', true};
      on_new_config = {config.on_new_config, 'f', true};
      on_attach = {config.on_attach, 'f', true};
    }
    config = tbl_extend("keep", config, default_config)

    local trigger
    if config.filetypes then
      trigger = "FileType "..table.concat(config.filetypes, ',')
    else
      trigger = "BufReadPost *"
    end
    api.nvim_command(string.format(
        "autocmd %s lua require'nvim_lsp'[%q].manager.try_add()"
        , trigger
        , config.name
        ))

    local get_root_dir = config.root_dir

    -- In the case of a reload, close existing things.
    if M.manager then
      for _, client in ipairs(M.manager.clients()) do
        client.stop(true)
      end
      M.manager = nil
    end
    local manager = util.server_per_root_dir_manager(function(_root_dir)
      local new_config = vim.tbl_extend("keep", {}, config)
      -- Deepcopy anything that is >1 level nested.
      new_config.settings = vim.deepcopy(new_config.settings)
      util.tbl_deep_extend(new_config.settings, default_config.settings)

      new_config.capabilities = new_config.capabilities or lsp.protocol.make_client_capabilities()
      util.tbl_deep_extend(new_config.capabilities, {
        workspace = {
          configuration = true;
        }
      })

      add_callbacks(new_config)
      if template.on_new_config then
        pcall(template.on_new_config, new_config)
      end
      if config.on_new_config then
        pcall(config.on_new_config, new_config)
      end

      new_config.on_init = util.add_hook_after(new_config.on_init, function(client, _result)
        function client.workspace_did_change_configuration(settings)
          if not settings then return end
          if vim.tbl_isempty(settings) then
            settings = {[vim.type_idx]=vim.types.dictionary}
          end
          return client.notify('workspace/didChangeConfiguration', {
            settings = settings;
          })
        end
        if new_config.settings then
          client.workspace_did_change_configuration(new_config.settings)
        end
      end)

      -- Save the old _on_attach so that we can reference it via the BufEnter.
      new_config._on_attach = new_config.on_attach
      new_config.on_attach = vim.schedule_wrap(function(client, bufnr)
        if bufnr == api.nvim_get_current_buf() then
          M._setup_buffer(client.id)
        else
          api.nvim_command(string.format(
              "autocmd BufEnter <buffer=%d> ++once lua require'nvim_lsp'[%q]._setup_buffer(%d)"
              , bufnr
              , template_name
              , client.id
              ))
        end
      end)
      return new_config
    end)

    function manager.try_add()
      local root_dir = get_root_dir(api.nvim_buf_get_name(0), api.nvim_get_current_buf())
      if not root_dir then return end
      local id = manager.add(root_dir)
      if id then
        lsp.buf_attach_client(0, id)
      end
    end

    M.manager = manager
  end

  function M._setup_buffer(client_id)
    local client = lsp.get_client_by_id(client_id)
    if client.config._on_attach then
      client.config._on_attach(client)
    end
    if template.commands then
      -- Create the module commands
      util.create_module_commands(template_name, M.commands)
    end
  end

  M.commands = template.commands
  M.name = template_name
  M.template_config = template

  rawset(t, template_name, M)

  return M
end

return setmetatable({}, skeleton)
-- vim:et ts=2 sw=2
