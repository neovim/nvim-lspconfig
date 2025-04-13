---@brief
---
-- https://github.com/elm-tooling/elm-language-server#installation
--
-- If you don't want to use Nvim to install it, then you can use:
-- ```sh
-- npm install -g elm elm-test elm-format @elm-tooling/elm-language-server
-- ```
return {
  cmd = { 'elm-language-server' },
  -- TODO(ashkan) if we comment this out, it will allow elmls to operate on elm.json. It seems like it could do that, but no other editor allows it right now.
  filetypes = { 'elm' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    if filetype == 'elm' or (filetype == 'json' and fname:match 'elm%.json$') then
      on_dir(vim.fs.root(bufnr, 'elm.json'))
      return
    end
    on_dir(nil)
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
