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

function M.tbl_deep_extend(dst, ...)
  validate { dst = { dst, 't' } }
  for i = 1, select("#", ...) do
    local t = select(i, ...)
    validate { arg = { t, 't' } }
    for k, v in pairs(t) do
      if type(v) == 'table' and not vim.tbl_islist(v) then
        dst[k] = M.tbl_deep_extend(dst[k] or {}, v)
      else
        dst[k] = v
      end
    end
  end
  return dst
end

function M.nvim_multiline_command(command)
  validate { command = { command, 's' } }
  for line in vim.gsplit(command, "\n", true) do
    api.nvim_command(line)
  end
end

function M.lookup_section(settings, section)
  for part in vim.gsplit(section, '.', true) do
    settings = settings[part]
  end
  return settings
end

function M.create_module_commands(module_name, commands)
  for command_name, def in pairs(commands) do
    local parts = {"command!"}
    -- Insert attributes.
    for k, v in pairs(def) do
      if type(k) == 'string' and type(v) == 'boolean' and v then
        table.insert(parts, "-"..k)
      elseif type(k) == 'number' and type(v) == 'string' and v:match("^%-") then
        table.insert(parts, v)
      end
    end
    table.insert(parts, command_name)
    -- The command definition.
    table.insert(parts,
        string.format("lua require'common_lsp/%s'.commands[%q][1]()", module_name, command_name))
    local command = table.concat(parts, " ")
    print(command)
    api.nvim_command(command)
  end
end


return M
-- vim:et ts=2 sw=2
