---@brief
---
--- https://docs.getdbt.com/docs/about-dbt-lsp
---
--- The dbt language server, built into the dbt v2 binary as `dbt lsp`. dbt Core 1.x and the
--- open-source `dbt-oss` build do not include it, and a dbt Core virtualenv can shadow the v2 `dbt`
--- on `$PATH`. For installation see
--- [Install dbt](https://docs.getdbt.com/docs/local/install-dbt?version=2).
---
--- Neovim does not detect a `dbt` filetype. A plugin such as
--- [dbt-ft.nvim](https://github.com/dobsontom/dbt-ft.nvim) sets it on a dbt project's `.sql` files,
--- for Jinja-aware highlighting.
---
--- The root is the outermost directory containing a `dbt_project.yml`, because every package in
--- `dbt_packages/` has its own.
---
--- Formatting is turned off, because the server formats the file on disk rather than the buffer and
--- so corrupts unsaved changes ([dbt-labs/dbt#16814](https://github.com/dbt-labs/dbt/issues/16814)).
---
--- `:LspDbtCompile` shows the compiled SQL of the current model in the preview window.

---@type vim.lsp.Config
return {
  cmd = { 'dbt', 'lsp' },
  filetypes = { 'sql', 'dbt' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local found = vim.fs.find('dbt_project.yml', { path = fname, upward = true, limit = math.huge })
    if #found > 0 then
      on_dir(vim.fs.dirname(found[#found]))
    end
  end,
  on_init = function(client)
    -- Off until https://github.com/dbt-labs/dbt/issues/16814 is fixed: dbt lsp edits the file on disk, not the buffer.
    client.server_capabilities.documentFormattingProvider = false
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspDbtCompile', function()
      client:exec_cmd({
        title = 'Compile',
        command = 'dbt.compileFile',
        arguments = { vim.uri_from_bufnr(bufnr) },
      }, { bufnr = bufnr }, function(err, result)
        local msg = err and err.message or result and result.error
        if msg and msg ~= vim.NIL then
          vim.notify(('dbt: %s'):format(msg), vim.log.levels.ERROR)
        elseif result and result.file_uri then
          vim.cmd.pedit(vim.uri_to_fname(result.file_uri))
        end
      end)
    end, { desc = 'Show compiled SQL' })
  end,
}
