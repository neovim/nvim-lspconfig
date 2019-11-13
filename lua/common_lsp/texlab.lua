local api = vim.api
local validate = vim.validate
local util = require 'common_lsp/util'
local lsp = vim.lsp

local M = {}

local texlab_build_status = vim.tbl_add_reverse_lookup {
	Success = 0;
	Error = 1;
	Failure = 2;
	Cancelled = 3;
}

function M.texlab_buf_build(bufnr)
	bufnr = util.validate_bufnr(bufnr)
	local params = { textDocument = { uri = vim.uri_from_bufnr(bufnr) }  }
	lsp.buf_request(bufnr, 'textDocument/build', params, function(err, method, result, client_id)
		if err then error(tostring(err)) end
		print("Build "..texlab_build_status[result.status])
	end)
end

-- bufnr isn't actually required here, but we need a valid buffer in order to
-- be able to find the client for buf_request.
-- TODO find a client by looking through buffers for a valid client?
function M.texlab_build_cancel_all(bufnr)
	bufnr = util.validate_bufnr(bufnr)
	local params = { token = "texlab-build-*" }
	lsp.buf_request(bufnr, 'window/progress/cancel', params, function(err, method, result, client_id)
		if err then error(tostring(err)) end
		print("Cancel result", vim.inspect(result))
	end)
end

-- TODO support more of https://github.com/microsoft/vscode-languageserver-node/blob/master/protocol/src/protocol.progress.proposed.md

local default_config
default_config = {
	name = "texlab";
	cmd = {"texlab"};
	filetype = {"tex"};
	build_log_level = lsp.protocol.MessageType.Warning;
	build_args = {"-pdf", "-interaction=nonstopmode", "-synctex=1"};
	build_executable = "latexmk";
	build_on_save = false;
	callbacks = {
		["window/logMessage"] = function(err, method, params, client_id)
			local client = lsp.get_client_by_id(client_id)
			-- TODO(ashkan) If the client died, then we might as well show everything?
			local build_log_level = client and client.config.build_log_level or lsp.protocol.MessageType.Log
			-- local build_log_level = client and client.config.build_log_level or default_config.build_log_level
			if params and params.type <= build_log_level then
				lsp.builtin_callbacks[method](err, method, params, client_id)
			end
		end
	}
}

local function run_command(command)
	validate { command = { command, 's' } }
	for line in vim.gsplit(command, "\n", true) do
		api.nvim_command(line)
	end
end

function M.texlab(config)
	config = vim.tbl_extend("keep", config, default_config)
	-- Deep merge is needed for callbacks.
	for method, fn in pairs(default_config.callbacks) do
		config.callbacks[method] = fn
	end
	config.on_attach = util.add_hook_after(config.on_attach, function(client, bufnr)
		if bufnr == api.nvim_get_current_buf() then
			M.texlab_setup_commands()
		else
			run_command(string.format("autocmd BufEnter <buffer=%d> ++once lua require'common_lsp/texlab'.texlab_setup_commands()", bufnr))
		end
	end)
	lsp.add_filetype_config(config)
end

function M.texlab_setup_commands()
	run_command [[
		command! TexlabBuild lua require'common_lsp/texlab'.texlab_buf_build(0)
	]]
end

return M
