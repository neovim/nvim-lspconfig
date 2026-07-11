---@meta

---@class _.lspconfig.settings.rome.Rome
---The rome lsp server executable. If the path is relative, the workspace folder will be used as base path
---@field lspBin? string
---Enable/Disable Rome handling renames in the workspace. (Experimental)
---@field rename? boolean
---Require a Rome configuration file to enable syntax errors, formatting and linting. Requires Rome 12 or newer.
---
---```lua
---default = true
---```
---@field requireConfiguration? boolean

---@class _.lspconfig.settings.rome.RomeLsp.Trace
---Traces the communication between VS Code and the language server.
---
---```lua
---default = "off"
---```
---@field server? "off" | "messages" | "verbose"

---@class _.lspconfig.settings.rome.RomeLsp
---@field trace? _.lspconfig.settings.rome.RomeLsp.Trace

---@class lspconfig.settings.rome
---@field rome? _.lspconfig.settings.rome.Rome
---@field rome_lsp? _.lspconfig.settings.rome.RomeLsp
