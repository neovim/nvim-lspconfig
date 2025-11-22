---@brief
---
--- https://github.com/denoland/deno
---
--- Deno's built-in language server
---
--- To appropriately highlight codefences returned from denols, you will need to augment vim.g.markdown_fenced languages
---  in your init.lua. Example:
---
--- ```lua
--- vim.g.markdown_fenced_languages = {
---   "ts=typescript"
--- }
--- ```

local lsp = vim.lsp

local function virtual_text_document_handler(uri, res, client)
  if not res then
    return nil
  end

  local lines = vim.split(res.result, '\n')
  local bufnr = vim.uri_to_bufnr(uri)

  local current_buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  if #current_buf ~= 0 then
    return nil
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value('readonly', true, { buf = bufnr })
  vim.api.nvim_set_option_value('modified', false, { buf = bufnr })
  vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
  lsp.buf_attach_client(bufnr, client.id)
end

local function virtual_text_document(uri, client)
  local params = {
    textDocument = {
      uri = uri,
    },
  }
  local result = client:request_sync('deno/virtualTextDocument', params)
  virtual_text_document_handler(uri, result, client)
end

local function denols_handler(err, result, ctx, config)
  if not result or vim.tbl_isempty(result) then
    return nil
  end

  local client = vim.lsp.get_client_by_id(ctx.client_id)
  for _, res in pairs(result) do
    local uri = res.uri or res.targetUri
    if uri:match '^deno:' then
      virtual_text_document(uri, client)
      res['uri'] = uri
      res['targetUri'] = uri
    end
  end

  lsp.handlers[ctx.method](err, result, ctx, config)
end

---@type vim.lsp.Config
return {
  cmd = { 'deno', 'lsp' },
  cmd_env = { NO_COLOR = true },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    local root_markers = { 'deno.lock' }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
      or vim.list_extend(root_markers, { '.git' })
    -- exclude non-deno projects (npm, yarn, pnpm, bun)
    local non_deno_path = vim.fs.root(
      bufnr,
      { 'package.json', 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    )
    local project_root = vim.fs.root(bufnr, root_markers)
    if non_deno_path and (not project_root or #non_deno_path >= #project_root) then
      return
    end
    -- We fallback to the current working directory if no project root is found
    on_dir(project_root or vim.fn.getcwd())
  end,
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ['https://deno.land'] = true,
          },
        },
      },
    },
  },
  handlers = {
    ['textDocument/definition'] = denols_handler,
    ['textDocument/typeDefinition'] = denols_handler,
    ['textDocument/references'] = denols_handler,
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspDenolsCache', function()
      client:exec_cmd({
        title = 'DenolsCache',
        command = 'deno.cache',
        arguments = { {}, vim.uri_from_bufnr(bufnr) },
      }, { bufnr = bufnr }, function(err, _, ctx)
        if err then
          local uri = ctx.params.arguments[2]
          vim.notify('cache command failed for' .. vim.uri_to_fname(uri), vim.log.levels.ERROR)
        end
      end)
    end, {
      desc = 'Cache a module and all of its dependencies.',
    })
  end,
}
