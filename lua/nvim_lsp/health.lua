local M = {}
function M.check_health()
  local configs = require 'nvim_lsp/configs'

  for _, top_level_config in pairs(configs) do
    -- the folder needs to exist
    local new_config = top_level_config.make_config(".")

    local cmd, _ = vim.lsp._cmd_parts(new_config.cmd)
    if not (vim.fn.executable(cmd) == 1) then
      vim.fn['health#report_error'](
        string.format("%s: The given command %q is not executable.", new_config.name, cmd)
      )
    else
      vim.fn['health#report_info'](
        string.format("%s: configuration checked.", new_config.name)
      )
    end
  end
end

return M
