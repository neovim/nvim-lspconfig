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
--- `:LspDbtShow` runs the current model and shows up to 20 of its rows there too.

local function preview_cell(value)
  if value == nil or value == vim.NIL then
    return 'NULL'
  end
  if type(value) == 'table' then
    value = vim.json.encode(value)
  end
  return (tostring(value):gsub('[\t\r\n]+', ' '))
end

local function read_bytes(path, start, stop)
  -- dbt sends zero-based, inclusive UTF-8 byte offsets.
  local ok, text = pcall(function()
    return vim.fn.readblob(path, start, stop - start + 1)
  end)
  return ok and text ~= '' and text or nil
end

local function show(client, bufnr, uri, inline)
  client:exec_cmd({
    title = 'Show',
    command = 'dbt.show',
    arguments = { { uri = uri, inline = inline, limit = 20 } },
  }, { bufnr = bufnr }, function(err, result)
    local msg = err and err.message or result and result.error
    if msg and msg ~= vim.NIL then
      vim.notify(('dbt: %s'):format(msg), vim.log.levels.ERROR)
    elseif result == nil then
      return -- The server dropped this request for a newer one.
    elseif type(result.columns) ~= 'table' then
      vim.notify('dbt: show returned no result', vim.log.levels.WARN)
    else
      local lines, widths = {}, {}
      for i, column in ipairs(result.columns) do
        local cells = { preview_cell(column) }
        for r, row in ipairs(result.data) do
          cells[r + 1] = preview_cell(row[column])
        end
        widths[i] = 0
        for r, cell in ipairs(cells) do
          -- 'vartabstop' takes at most 9999.
          widths[i] = math.min(9999, math.max(widths[i], vim.fn.strdisplaywidth(cell) + 2))
          lines[r] = (i > 1 and lines[r] .. '\t' or '') .. cell
        end
      end
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].bufhidden = 'wipe'
      vim.bo[buf].vartabstop = table.concat(widths, ',')
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.cmd(('pbuffer +setlocal\\ nowrap\\ nolist %d'):format(buf))
    end
  end)
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
      if vim.bo[ctx.bufnr].modified then
        vim.notify('dbt: save the model before previewing a CTE', vim.log.levels.WARN)
        return
      end
      local path, cte = command.arguments[1], command.arguments[2]
      -- The source range starts at the first CTE and omits Jinja set above it, so read the compiled SQL first.
      local sql = read_bytes(cte.compiled_path, cte.compiled_start, cte.compiled_stop)
        or read_bytes(path, cte.start, cte.stop)
      if not sql then
        vim.notify('dbt: could not read this CTE', vim.log.levels.WARN)
        return
      end
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      show(client, ctx.bufnr, vim.uri_from_fname(path), sql .. '\nSELECT * FROM ' .. cte.name)
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
          vim.cmd.pedit(vim.uri_to_fname(result.file_uri))
        end
      end)
    end, { desc = 'Show compiled SQL' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspDbtShow', function()
      show(client, bufnr, vim.uri_from_bufnr(bufnr))
    end, { desc = 'Preview model rows' })
  end,
}
