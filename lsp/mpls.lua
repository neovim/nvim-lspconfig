---@brief
---
--- https://github.com/mhersson/mpls
---
--- Markdown Preview Language Server

---@type vim.lsp.Config
return {
  cmd = {
    'mpls',
    '--theme',
    'dark',
    '--enable-emoji',
    '--enable-footnotes',
    '--no-auto',
  },
  root_markers = { '.marksman.toml', '.git' },
  filetypes = { 'markdown' },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = { '*.md' },
      group = vim.api.nvim_create_augroup('lspconfig.mpls.focus', { clear = true }),
      callback = function(ctx)
        ---@diagnostic disable-next-line:param-type-mismatch
        client:notify('mpls/editorDidChangeFocus', { uri = ctx.match })
      end,
      desc = 'mpls: notify buffer focus changed',
    })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspMplsOpenPreview', function()
      client:exec_cmd({
        title = 'Preview markdown with mpls',
        command = 'open-preview',
      })
    end, { desc = 'Preview markdown with mpls' })
  end,
}
