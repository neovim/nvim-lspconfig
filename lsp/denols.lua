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
  local result = client.request_sync('deno/virtualTextDocument', params)
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
  root_markers = { 'deno.json', 'deno.jsonc', '.git' },
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
    vim.api.nvim_buf_create_user_command(0, 'LspDenolsCache', function()
      client:exec_cmd({
        command = 'deno.cache',
        arguments = { {}, vim.uri_from_bufnr(bufnr) },
      }, { bufnr = bufnr }, function(err, _result, ctx)
        if err then
          local uri = ctx.params.arguments[2]
          vim.api.nvim_err_writeln('cache command failed for ' .. vim.uri_to_fname(uri))
        end
      end)
    end, {
      desc = 'Cache a module and all of its dependencies.',
    })
  end,
}
