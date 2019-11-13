local util = require 'common_lsp/util'
local api, validate, lsp = vim.api, vim.validate, vim.lsp
local inspect = vim.inspect

local M = {}

M.name = "SKELETON"

local default_config
default_config = {
  name = M.name;
  cmd = {"SKELETON"};
  filetype = {"SKELETON"};
  log_level = lsp.protocol.MessageType.Warning;
  settings = {};
}

local function setup_callbacks(config)
  config.callbacks = config.callbacks or {}

  config.callbacks["window/logMessage"] = function(err, method, params, client_id)
    if params and params.type <= config.log_level then
      lsp.builtin_callbacks[method](err, method, params, client_id)
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
        -- Uncomment this to debug.
        -- print(string.format("config[%q] = %s", item.section, inspect(value)))
        table.insert(result, value)
      end
    end
    return result
  end
end

-- A function to set up SKELETON easier.
--
-- Additionally, it sets up the following commands:
-- - SKELETON_SPOOKY_COMMAND: This does something SPOOKY.
-- - SKELETON_OTHER_COMMAND: This does some OTHER thing.
--
-- {config} is the same as |vim.lsp.add_filetype_config()|, but with some
-- additions and changes:
--
-- {name}
--   Defaults to "SKELETON"
--
-- {cmd}
--   Defaults to {"SKELETON"}
--
-- {filetype}
--   Defaults to {"SKELETON"}
--
-- {log_level}
--   controls the level of logs to show from build processes and other
--   window/logMessage events. By default it is set to
--   vim.lsp.protocol.MessageType.Warning instead of
--   vim.lsp.protocol.MessageType.Log.
--
-- {settings}
--   This is a table, and the keys are case sensitive.
--   Example: `settings = { }`
function M.setup(config)
  config = vim.tbl_extend("keep", config, default_config)

  util.tbl_deep_extend(config.settings, default_config.settings)

  config.capabilities = config.capabilities or lsp.protocol.make_client_capabilities()
  util.tbl_deep_extend(config.capabilities, {
    workspace = {
      configuration = true;
    }
  })

  setup_callbacks(config)

  config.on_attach = util.add_hook_after(config.on_attach, function(client, bufnr)
    if bufnr == api.nvim_get_current_buf() then
      M._setup_buffer()
    else
      api.nvim_command(string.format(
          "autocmd BufEnter <buffer=%d> ++once lua require'common_lsp/%s'._setup_buffer()",
          M.name,
          bufnr))
    end
  end)

  lsp.add_filetype_config(config)
end

-- Declare any commands here. You can use additional modifiers like "-range"
-- which will be added as command options. All of these commands are buffer
-- level by default.
M.commands = {
  SKELETON_FORMAT = {
    function()
      M.buf_SPOOKY_FUNCTION(0)
    end;
    "-range";
  };
  SKELETON_SPOOKY_COMMAND = {
    function()
      local bufnr = util.validate_bufnr(0)
      print("SPOOKY COMMAND STUFF!", bufnr)
    end;
  };
}

function M._setup_buffer()
  -- Do other setup here if you want.

  -- Create the module commands
  util.create_module_commands(M.name, M.commands)
end

function M.buf_SPOOKY_FUNCTION(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  print("SPOOKY FUNCTION STUFF!", bufnr)
end

return M
-- vim:et ts=2 sw=2

