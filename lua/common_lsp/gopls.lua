local util = require 'common_lsp/util'
local api, validate, lsp = vim.api, vim.validate, vim.lsp

local M = {}

M.name = "gopls"

local default_config
default_config = {
  name = M.name;
  cmd = {"gopls"};
  filetype = {"go"};
  root_dir = util.root_pattern("go.mod", ".git");
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

-- A function to set up `gopls` easier.
--
-- Additionally, it sets up the following commands:
-- - SKELETON_SPOOKY_COMMAND: This does something SPOOKY.
--
-- {config} is the same as |vim.lsp.add_filetype_config()|, but with some
-- additions and changes:
--
-- {root_dir}
--   REQUIRED function(filename, bufnr) which is called on new candidate
--   buffers to attach to and returns either a root_dir or nil.
--   If a root_dir is returned, then this file will also be attached. You can
--   optionally use {filetype} to help pre-filter by filetype.
--   If a root_dir is returned which differs from any previously returned
--   root_dir, a new server will be spawned with that root_dir.
--   If nil is returned, the buffer is skipped.

--   See |common_lsp.util.search_ancestors()| and the functions which use it:
--   - |common_lsp.util.root_pattern(patterns...)| finds an ancestor which a
--   descendent which has one of the files in `patterns...`. This is equivalent
--   to coc.nvim's "rootPatterns"
--   - More specific utilities:
--     - |common_lsp.util.find_git_root()|
--     - |common_lsp.util.find_node_modules_root()|
--     - |common_lsp.util.find_package_json_root()|
--
--   Defaults to common_lsp.util.root_pattern("go.mod", ".git")
--
-- {name}
--   Defaults to "gopls"
--
-- {cmd}
--   Defaults to {"gopls"}
--
-- {filetype}
--   Defaults to {"go"}. This is optional and only serves to reduce the scope
--   of files to filter for {root_dir}.
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
	validate {
		root_dir = {config.root_dir, 'f'};
		filetype = {config.filetype, 't', true};
	}

	if config.filetype then
    local filetypes
    if type(config.filetype) == 'string' then
      filetypes = { config.filetype }
    else
      filetypes = config.filetype
    end
		api.nvim_command(string.format(
				"autocmd FileType %s lua require'common_lsp/%s'.manager.try_add()"
				, table.concat(filetypes, ',')
				, M.name
				))
	else
		api.nvim_command(string.format(
				"autocmd BufReadPost * lua require'common_lsp/%s'.manager.try_add()"
				, M.name
				))
	end

	local get_root_dir = config.root_dir

	M.manager = util.server_per_root_dir_manager(function(_root_dir)
		local new_config = vim.tbl_extend("keep", config, default_config)
		-- Deepcopy anything that is >1 level nested.
		new_config.settings = vim.deepcopy(new_config.settings)
		util.tbl_deep_extend(new_config.settings, default_config.settings)

		new_config.capabilities = new_config.capabilities or lsp.protocol.make_client_capabilities()
		util.tbl_deep_extend(new_config.capabilities, {
			workspace = {
				configuration = true;
			}
		})

		setup_callbacks(new_config)

		new_config.on_attach = util.add_hook_after(new_config.on_attach, function(client, bufnr)
			if bufnr == api.nvim_get_current_buf() then
				M._setup_buffer()
			else
				api.nvim_command(string.format(
						"autocmd BufEnter <buffer=%d> ++once lua require'common_lsp/%s'._setup_buffer()",
						M.name,
						bufnr))
			end
		end)
		return new_config
	end)

	function M.manager.try_add()
    local root_dir = get_root_dir(api.nvim_buf_get_name(0), api.nvim_get_current_buf())
    print(api.nvim_get_current_buf(), root_dir)
		local id = M.manager.add(root_dir)
    lsp.buf_attach_client(0, id)
	end
end

-- Declare any commands here. You can use additional modifiers like "-range"
-- which will be added as command options. All of these commands are buffer
-- level by default.
M.commands = {
  SKELETON_SPOOKY_COMMAND = {
    function()
      local bufnr = util.validate_bufnr(0)
      print("SPOOKY COMMAND STUFF!", bufnr)
    end;
  };
}

function M._setup_buffer()
  -- Create the module commands
  util.create_module_commands(M.name, M.commands)
end

return M
-- vim:et ts=2 sw=2


