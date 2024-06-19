local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'lsp-ai' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
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
