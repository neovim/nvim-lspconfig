---@meta

---@class _.lspconfig.settings.awk_ls.AwkIdeVscode.Trace
---Traces the communication between VS Code and the language server.
---
---```lua
---default = "off"
---```
---@field server? "off" | "messages" | "verbose"

---@class _.lspconfig.settings.awk_ls.AwkIdeVscode
---Turns on/off source files indexing. Requires restart.
---
---```lua
---default = true
---```
---@field indexing? boolean
---@field trace? _.lspconfig.settings.awk_ls.AwkIdeVscode.Trace

---@class lspconfig.settings.awk_ls
---@field ["awk-ide-vscode"]? _.lspconfig.settings.awk_ls.AwkIdeVscode
