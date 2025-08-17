---@brief
---
--- https://github.com/vuejs/language-tools/tree/master/packages/language-server
---
--- The official language server for Vue
---
--- It can be installed via npm:
--- ```sh
--- npm install -g @vue/language-server
--- ```
---
--- The language server only supports Vue 3 projects by default.
--- For Vue 2 projects, [additional configuration](https://github.com/vuejs/language-tools/blob/master/extensions/vscode/README.md?plain=1#L19) are required.
---
--- The Vue language server works in "hybrid mode" that exclusively manages the CSS/HTML sections.
--- You need the `vtsls` server with the `@vue/typescript-plugin` plugin to support TypeScript in `.vue` files.
--- See `vtsls` section and https://github.com/vuejs/language-tools/wiki/Neovim for more information.
---
--- NOTE: Since v3.0.0, the Vue Language Server [no longer supports takeover mode](https://github.com/vuejs/language-tools/pull/5248).

return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json' },
  on_init = function(client)
    client.handlers['tsserver/request'] = function(_, result, context)
      local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })
      local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
      local clients = {}

      vim.list_extend(clients, ts_clients)
      vim.list_extend(clients, vtsls_clients)

      if #clients == 0 then
        vim.notify('Could not find `ts_ls` or `vtsls` lsp client, required by `vue_ls`.', vim.log.levels.ERROR)
        return
      end
      local ts_client = clients[1]

      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
        command = 'typescript.tsserverRequest',
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
        local response_data = { { id, r and r.body } }
        ---@diagnostic disable-next-line: param-type-mismatch
        client:notify('tsserver/response', response_data)
      end)
    end
  end,
}
