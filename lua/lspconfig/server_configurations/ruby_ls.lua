local util = require 'lspconfig.util'

local bin_name = 'ruby-lsp'

-- defaults to stdio
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'ruby' },
    root_dir = util.root_pattern('Gemfile', '.git'),
    init_options = {
      enabledFeatures = {
        'codeActions',
        'diagnostics',
        'documentHighlights',
        'documentSymbols',
        'formatting',
        'inlayHint',
      },
    },
  },
  docs = {
    description = [[
https://shopify.github.io/ruby-lsp/

This gem is an implementation of the language server protocol specification for
Ruby, used to improve editor features.

Install the gem. There's no need to require it, since the server is used as a
standalone executable.

```sh
group :development do
  gem "ruby-lsp", require: false
end
```

Neovim implements the `textDocument/publishDiagnostic` specification
for the diagnostics feature. Where the server notifies the client with this event.

However, ruby-lsp since the version `0.2.2` does not support this
specification for diagnostics.
Instead, it implements the `textDocument/pullDiagnostic` specification,
that expects the client to send `textDocument/diagnostic` requests to the server
when the client want diagnostics updates.

In order to `nvim-lspconfig` fully enable the diagnostic feature,
it would be necessary either use an old version of `ruby-lsp < 0.2.2` or
add an autocommand to send the diagnostics request when the buffer changes.

The suggested setup would make diagnostics work with recent versions of `ruby_lsp` by
making the client send `textDocument/diagnostic` requests to the server
when the buffer changes and use the response to simulate how neovim would handle
the message for the event `textDocument/publishDiagnostic` if it have been received.

```lua
require('lspconfig')['ruby_ls'] {
  on_attach = function(client, buffer)
    -- in the case you have an existing `on_attach` function
    -- with mappings you share with other lsp clients configs
    pcall(on_attach, client, buffer)

    local diagnostic_handler = function ()
      local params = vim.lsp.util.make_text_document_params(buffer)

      client.request(
        'textDocument/diagnostic',
        {textDocument = params},
        function(err, result)
          if err then
            local err_msg = string.format("ruby-lsp - diagnostics error - %s", vim.inspect(err))
            vim.lsp.log.error(err_msg)
          end
          if not result then return end

          vim.lsp.diagnostic.on_publish_diagnostics(
            nil,
            vim.tbl_extend('keep', params, { diagnostics = result.items }),
            { client_id = client.id }
          )
        end
      )
    end

    diagnostic_handler() -- to request diagnostics when attaching the client to the buffer

    local ruby_group = vim.api.nvim_create_augroup('ruby_ls', {clear = false})
    vim.api.nvim_create_autocmd(
      {'BufEnter', 'BufWritePre', 'InsertLeave', 'TextChanged'},
      {
        buffer = buffer,
        callback = diagnostic_handler,
        group = ruby_group,
      }
    )
  end
}
```
    ]],
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]],
    },
  },
}
