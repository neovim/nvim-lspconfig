---@brief
---
--- https://github.com/iamcco/ds-pinyin-lsp
--- Dead simple Pinyin language server for input Chinese without IME(input method).
--- To install, download the latest [release](https://github.com/iamcco/ds-pinyin-lsp/releases) and ensure `ds-pinyin-lsp` is on your path.
--- And make ensure the database file `dict.db3` is also downloaded. And put the path to `dict.dbs` in the following code.
---
--- ```lua
---
--- vim.lsp.config('ds_pinyin_lsp', {
---     init_options = {
---         db_path = "your_path_to_database"
---     }
--- })
---
--- ```

local bin_name = 'ds-pinyin-lsp'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.exe'
end

local function ds_pinyin_lsp_off(bufnr)
  local ds_pinyin_lsp_client = vim.lsp.get_clients({ bufnr = bufnr, name = 'ds_pinyin_lsp' })[1]
  if ds_pinyin_lsp_client then
    ds_pinyin_lsp_client.notify('$/turn/completion', {
      ['completion_on'] = false,
    })
  else
    vim.notify 'notification $/turn/completion is not supported by any servers active on the current buffer'
  end
end

local function ds_pinyin_lsp_on(bufnr)
  local ds_pinyin_lsp_client = vim.lsp.get_clients({ bufnr = bufnr, name = 'ds_pinyin_lsp' })[1]
  if ds_pinyin_lsp_client then
    ds_pinyin_lsp_client.notify('$/turn/completion', {
      ['completion_on'] = true,
    })
  else
    vim.notify 'notification $/turn/completion is not supported by any servers active on the current buffer'
  end
end

return {
  cmd = { bin_name },
  filetypes = { 'markdown', 'org' },
  root_markers = { '.git' },
  init_options = {
    completion_on = true,
    show_symbols = true,
    show_symbols_only_follow_by_hanzi = false,
    show_symbols_by_n_times = 0,
    match_as_same_as_input = true,
    match_long_input = true,
    max_suggest = 15,
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspDsPinyinCompletionOff', function()
      ds_pinyin_lsp_off(bufnr)
    end, { desc = 'Turn off the ds-pinyin-lsp completion' })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspDsPinyinCompletionOn', function()
      ds_pinyin_lsp_on(bufnr)
    end, { desc = 'Turn on the ds-pinyin-lsp completion' })
  end,
}
