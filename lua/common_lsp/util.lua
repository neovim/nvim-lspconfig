local validate = vim.validate
local api = vim.api

local M = {}

function M.validate_bufnr(bufnr)
	validate {
		bufnr = { bufnr, 'n' }
	}
	return bufnr == 0 and api.nvim_get_current_buf() or bufnr
end

function M.add_hook_before(fn, new_fn)
	if fn then
		return function(...)
			-- TODO which result?
			new_fn(...)
			return fn(...)
		end
	else
		return new_fn
	end
end

function M.add_hook_after(fn, new_fn)
	if fn then
		return function(...)
			-- TODO which result?
			fn(...)
			return new_fn(...)
		end
	else
		return new_fn
	end
end

local function split_lines(s)
	return vim.split(s, "\n", true)
end

return M
