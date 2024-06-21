local util = require 'lspconfig.util'

local generation = function(bufnr)
  local client = util.get_active_client_by_name(bufnr, 'lsp_ai')
  local line, character = unpack(vim.api.nvim_win_get_cursor(0))
  if client then
    local completion = client.config.init_options.completion
    local payload = {
      textDocument = {
        uri = vim.uri_from_bufnr(bufnr),
      },
      position = {
        line = line - 1,
        character = character,
      },
      model = completion.model,
      parameters = completion.parameters
    }
    client.request('textDocument/generation', payload, function(error_, result)
      if error_ then
        vim.notify(tostring(error_), vim.log.levels.ERROR)
      end

      local split = {};
      for line_ in string.gmatch(result['generatedText'] .. "\n", "(.-)\n") do
        table.insert(split, line_);
      end

      vim.api.nvim_buf_set_text(
        bufnr,
        line - 1,
        character,
        line - 1,
        character,
        split
      )
    end, bufnr)
  else
    vim.notify(
      'Method "textDocument/generation" is not supported by any server in the current buffer',
      vim.log.levels.WARN
    )
  end
end

return {
  default_config = {
    cmd = { 'lsp-ai' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    commands = {
      LspAiGenerate = {
        function()
          generation(0)
        end,
        description = 'Generate'
      }
    },
    init_options = {
      memory = {
        file_store = {}
      },

      models = {
        model1 = {
          type = 'ollama',
          model = 'deepseek-coder',
        }
      },

      completion = {
        model = 'model1',
        parameters = {
          fim = {
            start = "<|fim_begin|>",
            middle = "<|fim_hole|>",
            ["end"] = "<|fim_end|>"
          },
          max_context = 2000,
          options = {
            num_predict = 32
          }
        }
      }
    }
  },
  docs = {
    description = [[
https://github.com/SilasMarvin/lsp-ai

`lsp-ai` can be installed via 'cargo':

```sh
cargo install lsp-ai
```
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
