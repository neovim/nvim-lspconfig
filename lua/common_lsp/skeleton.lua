local api = vim.api
local validate = vim.validate
local util = require 'common_lsp/util'
local lsp = vim.lsp

local M = {}

local default_config
default_config = {
  name = "SKELETON";
  cmd = {"SKELETON"};
  filetype = {"c", "cpp"};
	SKELETON_log_level = lsp.protocol.MessageType.Warning;
	SKELETON_settings = {};
}

local function setup_callbacks(config)
  config.callbacks = config.callbacks or {}

  config.callbacks["window/logMessage"] = function(err, method, params, client_id)
    if params and params.type <= config.texlab_log_level then
      lsp.builtin_callbacks[method](err, method, params, client_id)
    end
  end

  -- TODO use existing callback?
  config.callbacks["workspace/configuration"] = function(err, method, params, client_id)
    if err then error(tostring(err)) end
    if not params.items then
      return {}
    end

    local result = {}
    for _, item in ipairs(params.items) do
      if item.section then
        local value = util.lookup_section(config, item.section) or vim.NIL
        print(string.format("config[%q] = %s", item.section, vim.inspect(value)))
        table.insert(result, value)
      end
    end
    return result
  end
end

-- A function to set up SKELETON easier.
--
-- Additionally, it sets up the following commands:
-- - SKELETONCommand
--
-- {config} is the same as |vim.lsp.add_filetype_config()|, but with some
-- additions and changes:
--
-- {SKELETON_log_level}
--   controls the level of logs to show from build processes and other
--   window/logMessage events. By default it is set to
--   vim.lsp.protocol.MessageType.Warning instead of
--   vim.lsp.protocol.MessageType.Log.
--
-- {SKELETON_settings}
--   This is a table, and the keys are case sensitive.
--   Example: `SKELETON_settings = { }`
--
-- {filetype}
--   Defaults to {"c", "cpp"}
--
-- {cmd}
--   Defaults to {"SKELETON"}
--
-- {name}
--   Defaults to "SKELETON"
function M.setup(config)
  config = vim.tbl_extend("keep", config, default_config)

  util.tbl_deep_extend(config.settings, default_config.settings)

  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
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
      util.nvim_multiline_command(string.format("autocmd BufEnter <buffer=%d> ++once lua require'common_lsp/SKELETON'._setup_buffer()", bufnr))
    end
  end)

	-- TODO should this find the project root instead?
  lsp.add_filetype_config(config)
end

function M._setup_buffer()
  util.nvim_multiline_command [[
  ]]
end

return M
-- vim:et ts=2 sw=2

