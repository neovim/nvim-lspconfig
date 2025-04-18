---@brief
---
-- https://github.com/japhib/pico8-ls
--
-- Full language support for the PICO-8 dialect of Lua.
return {
  cmd = { 'pico8-ls', '--stdio' },
  filetypes = { 'p8' },
  root_markers = function(name, _)
    return vim.glob.to_lpeg('*.p8'):match(name) ~= nil
  end,
  settings = {},
}
