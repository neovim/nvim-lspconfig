local util = require 'lspconfig.util'
local api = vim.api

local elm_root_pattern = util.root_pattern 'elm.json'

---@brief
---
---https://github.com/elm-tooling/elm-language-server#installation
--
-- If you don't want to use Nvim to install it, then you can use:
-- ```sh
-- npm install -g elm elm-test elm-format @elm-tooling/elm-language-server
-- ```
return {
  cmd = { 'elm-language-server' },
  -- TODO(ashkan) if we comment this out, it will allow elmls to operate on elm.json. It seems like it could do that, but no other editor allows it right now.
  filetypes = { 'elm' },
  root_dir = function(bufnr, done_callback)
    local fname = api.nvim_buf_get_name(bufnr)
    local filetype = api.nvim_buf_get_option(0, 'filetype')
    if filetype == 'elm' or (filetype == 'json' and fname:match 'elm%.json$') then
      done_callback(elm_root_pattern(fname))
      return
    end
    done_callback(nil)
  end,
  init_options = {
    elmReviewDiagnostics = 'off', -- 'off' | 'warning' | 'error'
    skipInstallPackageConfirmation = false,
    disableElmLSDiagnostics = false,
    onlyUpdateDiagnosticsOnSave = false,
  },
  capabilities = {
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
}
