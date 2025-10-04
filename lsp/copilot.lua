---@brief
---
--- https://www.npmjs.com/package/@github/copilot-language-server
---
--- The Copilot Language Server enables any editor or IDE
--- to integrate with GitHub Copilot via
--- [the language server protocol](https://microsoft.github.io/language-server-protocol/).
---
--- **[GitHub Copilot](https://github.com/features/copilot)**
--- is an AI pair programmer tool that helps you write code faster and smarter.
---
--- **Sign up for [GitHub Copilot Free](https://github.com/settings/copilot)!**
---
--- Please see [terms of use for GitHub Copilot](https://docs.github.com/en/site-policy/github-terms/github-terms-for-additional-products-and-features#github-copilot)
---
--- You need to enable `:help lsp-inline-completion` to receive suggestions. For example, you can enable it in the LspAttach event:
---
--- ```lua
--- vim.api.nvim_create_autocmd('LspAttach', {
---   callback = function(args)
---     local bufnr = args.buf
---     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
---
---     if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
---       vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
---
---       vim.keymap.set(
---         'i',
---         '<C-F>',
---         vim.lsp.inline_completion.get,
---         { desc = 'LSP: accept inline completion', buffer = bufnr }
---       )
---       vim.keymap.set(
---         'i',
---         '<C-G>',
---         vim.lsp.inline_completion.select,
---         { desc = 'LSP: switch inline completion', buffer = bufnr }
---       )
---     end
---   end
--- })
--- ```

---@param bufnr integer,
---@param client vim.lsp.Client
local function sign_in(bufnr, client)
  client:request(
    ---@diagnostic disable-next-line: param-type-mismatch
    'signIn',
    vim.empty_dict(),
    function(err, result)
      if err then
        vim.notify(err.message, vim.log.levels.ERROR)
        return
      end
      if result.command then
        local code = result.userCode
        local command = result.command
        vim.fn.setreg('+', code)
        vim.fn.setreg('*', code)
        local continue = vim.fn.confirm(
          'Copied your one-time code to clipboard.\n' .. 'Open the browser to complete the sign-in process?',
          '&Yes\n&No'
        )
        if continue == 1 then
          client:exec_cmd(command, { bufnr = bufnr }, function(cmd_err, cmd_result)
            if cmd_err then
              vim.notify(err.message, vim.log.levels.ERROR)
              return
            end
            if cmd_result.status == 'OK' then
              vim.notify('Signed in as ' .. cmd_result.user .. '.')
            end
          end)
        end
      end

      if result.status == 'PromptUserDeviceFlow' then
        vim.notify('Enter your one-time code ' .. result.userCode .. ' in ' .. result.verificationUri)
      elseif result.status == 'AlreadySignedIn' then
        vim.notify('Already signed in as ' .. result.user .. '.')
      end
    end
  )
end

---@param client vim.lsp.Client
local function sign_out(_, client)
  client:request(
    ---@diagnostic disable-next-line: param-type-mismatch
    'signOut',
    vim.empty_dict(),
    function(err, result)
      if err then
        vim.notify(err.message, vim.log.levels.ERROR)
        return
      end
      if result.status == 'NotSignedIn' then
        vim.notify('Not signed in.')
      end
    end
  )
end

---@type vim.lsp.Config
return {
  cmd = {
    'copilot-language-server',
    '--stdio',
  },
  root_markers = { '.git' },
  init_options = {
    editorInfo = {
      name = 'Neovim',
      version = tostring(vim.version()),
    },
    editorPluginInfo = {
      name = 'Neovim',
      version = tostring(vim.version()),
    },
  },
  settings = {
    telemetry = {
      telemetryLevel = 'all',
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCopilotSignIn', function()
      sign_in(bufnr, client)
    end, { desc = 'Sign in Copilot with GitHub' })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCopilotSignOut', function()
      sign_out(bufnr, client)
    end, { desc = 'Sign out Copilot with GitHub' })
  end,
}
