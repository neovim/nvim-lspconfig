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
--- To preview a CTE in a saved model, put the cursor on the line where the CTE starts
--- and call `vim.lsp.codelens.run()`. On Neovim 0.11, call `vim.lsp.codelens.refresh()` first.

local function preview_cell(value)
  if value == nil or value == vim.NIL then
    return 'NULL'
  end
  if type(value) == 'table' then
    value = vim.json.encode(value)
  end
  return (tostring(value):gsub('\\', '\\\\'):gsub('|', '\\|'):gsub('[\r\n]+', ' '))
end

local function preview_rows(columns, rows, title)
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
  vim.lsp.util.open_floating_preview(lines, 'markdown', { title = title })
end

local function request_preview(client, bufnr, uri, inline)
  local kind = inline and 'CTE' or 'model'
  client:exec_cmd({
    title = 'Preview ' .. kind .. ' rows',
    command = 'dbt.show',
    arguments = { { uri = uri, inline = inline, limit = 20 } },
  }, { bufnr = bufnr }, function(err, result)
    local message = err and err.message or type(result) == 'table' and result.error
    if message and message ~= vim.NIL then
      vim.notify(('dbt: %s'):format(message), vim.log.levels.ERROR)
    elseif type(result) ~= 'table' or type(result.columns) ~= 'table' or type(result.data) ~= 'table' then
      vim.notify('dbt: ' .. kind .. ' preview returned no result', vim.log.levels.WARN)
    elseif vim.api.nvim_get_current_buf() == bufnr then
      preview_rows(result.columns, result.data, 'dbt ' .. kind .. ' preview')
    end
  end)
end

local function read_cte(path, start_byte, stop_byte)
  if type(path) ~= 'string' or type(start_byte) ~= 'number' or type(stop_byte) ~= 'number' then
    return
  end
  if start_byte < 0 or stop_byte < start_byte then
    return
  end
  -- dbt sends zero-based, inclusive UTF-8 byte offsets.
  local size = stop_byte - start_byte + 1
  local ok, text = pcall(vim.fn.readblob, path, start_byte, size)
  if ok and #text == size then
    return text
  end
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
  commands = {
    ['dbt.previewCte'] = function(command, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if not client or not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
        return
      end
      if vim.bo[ctx.bufnr].modified then
        vim.notify('dbt: save the model before previewing a CTE', vim.log.levels.WARN)
        return
      end

      local args = type(command.arguments) == 'table' and command.arguments or {}
      local source_path, cte = args[1], args[2]
      if type(source_path) ~= 'string' or type(cte) ~= 'table' or type(cte.name) ~= 'string' then
        vim.notify('dbt: invalid CTE preview arguments', vim.log.levels.WARN)
        return
      end
      local sql = read_cte(cte.compiled_path, cte.compiled_start, cte.compiled_stop)
        or read_cte(source_path, cte.start, cte.stop)
      if not sql then
        vim.notify('dbt: could not read SQL for this CTE', vim.log.levels.WARN)
        return
      end
      request_preview(client, ctx.bufnr, vim.uri_from_fname(source_path), sql .. '\nSELECT * FROM ' .. cte.name)
    end,
  },
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
      request_preview(client, bufnr, vim.uri_from_bufnr(bufnr))
    end, { desc = 'Preview model rows' })
  end,
}
