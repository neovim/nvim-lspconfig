---@brief
---
--- https://github.com/SilasMarvin/lsp-ai
---
--- LSP-AI is an open source language server that serves as a backend for AI-powered functionality in your favorite code
--- editors. It offers features like in-editor chatting with LLMs and code completions.
---
---
--- You will need to provide configuration for the inference backends and models you want to use, as well as configure
--- completion/code actions. See the [wiki docs](https://github.com/SilasMarvin/lsp-ai/wiki/Configuration) and
--- [examples](https://github.com/SilasMarvin/lsp-ai/blob/main/examples/nvim) for more information.
return {
  cmd = { 'lsp-ai' },
  filetypes = {},
  root_dir = nil,
  init_options = {
    memory = {
      file_store = vim.empty_dict(),
    },
    models = vim.empty_dict(),
  },
}
