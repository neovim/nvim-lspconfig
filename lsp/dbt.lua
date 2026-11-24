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
--- `:LspDbtShow` runs the current model and previews up to 20 rows.

local function preview_cell(value)
  if value == nil or value == vim.NIL then
    return 'NULL'
  end
  if type(value) == 'table' then
    value = vim.json.encode(value)
  end
  return (tostring(value):gsub('\\', '\\\\'):gsub('|', '\\|'):gsub('[\r\n]+', ' '))
end

local function preview_rows(columns, rows)
  local lines = { 'No rows returned.' }
  if #rows > 0 then
    lines = {
      '| ' .. table.concat(vim.tbl_map(preview_cell, columns), ' | ') .. ' |',
      '| ' .. string.rep('--- | ', #columns),
    }
    for _, row in ipairs(rows) do
      local cells = {}
      for i, column in ipairs(columns) do
        cells[i] = preview_cell(row[column])
      end
      lines[#lines + 1] = '| ' .. table.concat(cells, ' | ') .. ' |'
    end
  end
  vim.lsp.util.open_floating_preview(lines, 'markdown', { title = 'dbt model preview' })
end

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
          vim.cmd.pedit(vim.fn.fnameescape(vim.uri_to_fname(result.file_uri)))
        end
      end)
    end, { desc = 'Show compiled SQL' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspDbtShow', function()
      client:exec_cmd({
        title = 'Preview model rows',
        command = 'dbt.show',
        arguments = { { uri = vim.uri_from_bufnr(bufnr), limit = 20 } },
      }, { bufnr = bufnr }, function(err, result)
        local message = err and err.message or type(result) == 'table' and result.error
        if message and message ~= vim.NIL then
          vim.notify(('dbt: %s'):format(message), vim.log.levels.ERROR)
        elseif type(result) ~= 'table' or type(result.columns) ~= 'table' or type(result.data) ~= 'table' then
          vim.notify('dbt: model preview returned no result', vim.log.levels.WARN)
        elseif vim.api.nvim_get_current_buf() == bufnr then
          preview_rows(result.columns, result.data)
        end
      end)
    end, { desc = 'Preview model rows' })
  end,
}
