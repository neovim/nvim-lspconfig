---@brief
---
--- https://github.com/typescript-language-server/typescript-language-server
---
--- `ts_ls`, aka `typescript-language-server`, is a Language Server Protocol implementation for TypeScript wrapping `tsserver`. Note that `ts_ls` is not `tsserver`.
---
--- `typescript-language-server` depends on `typescript`. Both packages can be installed via `npm`:
--- ```sh
--- npm install -g typescript typescript-language-server
--- ```
---
--- To configure typescript language server, add a
--- [`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html) or
--- [`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to the root of your
--- project.
---
--- Here's an example that disables type checking in JavaScript files.
---
--- ```json
--- {
---   "compilerOptions": {
---     "module": "commonjs",
---     "target": "es6",
---     "checkJs": false
---   },
---   "exclude": [
---     "node_modules"
---   ]
--- }
--- ```
---
--- Use the `:LspTypescriptSourceAction` command to see "whole file" ("source") code-actions such as:
--- - organize imports
--- - remove unused code
---
--- ### Vue support
---
--- As of 2.0.0, the Vue language server no longer supports TypeScript itself. Instead, a plugin
--- adds Vue support to this language server.
---
--- *IMPORTANT*: It is crucial to ensure that `@vue/typescript-plugin` and `@vue/language-server `are of identical versions.
---
--- ```lua
--- vim.lsp.config('ts_ls', {
---   init_options = {
---     plugins = {
---       {
---         name = "@vue/typescript-plugin",
---         location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
---         languages = {"javascript", "typescript", "vue"},
---       },
---     },
---   },
---   filetypes = {
---     "javascript",
---     "typescript",
---     "vue",
---   },
--- })
---
--- -- You must make sure the Vue language server is setup
--- -- e.g. vim.lsp.config('vue_ls')
--- -- See vue_ls's section for more information
--- ```
---
--- `location` MUST be defined. If the plugin is installed in `node_modules`,
--- `location` can have any value.
---
--- `languages` must include `vue` even if it is listed in `filetypes`.
---
--- `filetypes` is extended here to include Vue SFC.

return {
  init_options = { hostInfo = 'neovim' },
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  handlers = {
    -- handle rename request for certain code actions like extracting functions / types
    ['_typescript.rename'] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      vim.lsp.util.show_document({
        uri = result.textDocument.uri,
        range = {
          start = result.position,
          ['end'] = result.position,
        },
      }, client.offset_encoding)
      vim.lsp.buf.rename()
      return vim.NIL
    end,
  },
  on_attach = function(client)
    -- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
    -- `vim.lsp.buf.code_action()` if specified in `context.only`.
    vim.api.nvim_buf_create_user_command(0, 'LspTypescriptSourceAction', function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, 'source.')
      end, client.server_capabilities.codeActionProvider.codeActionKinds)

      vim.lsp.buf.code_action({
        context = {
          only = source_actions,
        },
      })
    end, {})
  end,
}
