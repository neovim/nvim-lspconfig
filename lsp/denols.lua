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
---
--- Some care must be taken here to correctly infer whether a file is part of a Deno program, or a TS program that
--- expects to run in Node or Web Browsers. This supports having a Deno module that is a part of a mostly-not-Deno
--- monorepo. We do this by finding the nearest package manager lock file, and the nearest deno.json or deno.jsonc.
--- Note that this means that without a deno.json, deno.jsonc, or deno.lock file, this LSP client will not attach.
---
--- Example:
---
--- ```
--- project-root
--- +-- node_modules/...
--- +-- package-lock.json
--- +-- package.json
--- +-- packages
---     +-- deno-module
---     |   +-- deno.json
---     |   +-- package.json <-- It's normal for Deno projects to have package.json files!
---     |   +-- src
---     |       +-- index.ts <-- this is a Deno file
---     +-- node-module
---         +-- package.json
---         +-- src
---             +-- index.ts <-- a non-Deno file (ie, should use ts_ls or tsgo)
--- ```
---
--- From the file being edited, we walk up to find the nearest package manager lockfile. This is PROJECT ROOT.
--- From the file being edited, find the nearest deno.json or deno.jsonc. This is DENO ROOT.
--- From the file being edited, find the nearest deno.lock. This is DENO LOCK ROOT
--- If DENO LOCK ROOT is found, and PROJECT ROOT is missing or shorter, then this is a deno file, and we attach.
--- If DENO ROOT is found, and it's longer than or equal to PROJECT ROOT, then this is a Deno file, and we attach.
--- Otherwise, we abort, because this is a non-Deno TS file.

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
    local root_markers = { 'deno.lock', 'deno.json', 'deno.jsonc' }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
      or vim.list_extend(root_markers, { '.git' })
    -- only include deno projects
    local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
    local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
    local project_root = vim.fs.root(bufnr, root_markers)
    if
      (deno_lock_root and (not project_root or #deno_lock_root > #project_root))
      or (deno_root and (not project_root or #deno_root >= #project_root))
    then
      -- deno config is closer than or equal to package manager lock,
      -- or deno lock is closer than package manager lock. Attach at the project root,
      -- or deno lock or deno config path. At least one of these is always set at this point.
      on_dir(project_root or deno_lock_root or deno_root)
    end
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
