---@meta

---The evaluation section, provide auto completion for dynamic bindings.
---@class _.lspconfig.settings.nixd.Nixd.Eval
---Extra depth for evaluation
---
---```lua
---default = 0
---```
---@field depth? integer
---@field target? any
---The number of workers for evaluation task. defaults to std::thread::hardware_concurrency
---@field workers? integer

---Tell the language server your desired option set, for completion. This is lazily evaluated.
---@class _.lspconfig.settings.nixd.Nixd.Options
---Enable option completion task. If you are writing a package, disable this
---
---```lua
---default = "false"
---```
---@field enable? boolean
---@field target? any

---@class _.lspconfig.settings.nixd.Nixd
---The evaluation section, provide auto completion for dynamic bindings.
---@field eval? _.lspconfig.settings.nixd.Nixd.Eval
---@field formatting? any
---Tell the language server your desired option set, for completion. This is lazily evaluated.
---@field options? _.lspconfig.settings.nixd.Nixd.Options

---@class lspconfig.settings.nixd
---@field nixd? _.lspconfig.settings.nixd.Nixd
