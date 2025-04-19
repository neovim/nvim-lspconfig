---@brief
---
--- https://github.com/Feel-ix-343/markdown-oxide
---
--- Editor Agnostic PKM: you bring the text editor and we
--- bring the PKM.
---
--- Inspired by and compatible with Obsidian.
---
--- Check the readme to see how to properly setup.
return {
  root_markers = { '.obsidian', '.moxide.toml' },
  filetypes = { 'markdown' },
  cmd = { 'markdown-oxide' },
  on_attach = function()
    vim.api.nvim_buf_create_user_command(0, 'Today', function()
      vim.lsp.buf.execute_command { command = 'jump', arguments = { 'today' } }
    end, {
      desc = "Open today's daily note",
    })
    vim.api.nvim_buf_create_user_command(0, 'Tomorrow', function()
      vim.lsp.buf.execute_command { command = 'jump', arguments = { 'tomorrow' } }
    end, {
      desc = "Open tomorrow's daily note",
    })
    vim.api.nvim_buf_create_user_command(0, 'Yesterday', function()
      vim.lsp.buf.execute_command { command = 'jump', arguments = { 'yesterday' } }
    end, {
      desc = "Open yesterday's daily note",
    })
  end,
}
