---@meta

---@class _.lspconfig.settings.c3_lsp.C3lspclient.Lsp.C3
---Path to C3C binary. Use it if not defined already in your PATH environment variable or if you want to use a different one.
---@field path? string
---Path to C3 standard library sources. Allows stdlib inspections.
---@field stdlibPath? string

---@class _.lspconfig.settings.c3_lsp.C3lspclient.Lsp.Log
---Saves log to specified file
---
---```lua
---default = ""
---```
---@field path? string

---@class _.lspconfig.settings.c3_lsp.C3lspclient.Lsp
---@field c3? _.lspconfig.settings.c3_lsp.C3lspclient.Lsp.C3
---Enables debug information logging
---
---```lua
---default = true
---```
---@field debug? boolean
---Delay calculation of code diagnostics after modifications in source. In milliseconds, default 2000 ms.
---
---```lua
---default = 2000
---```
---@field diagnosticsDelay? integer
---Enables the language server
---
---```lua
---default = true
---```
---@field enable? boolean
---@field log? _.lspconfig.settings.c3_lsp.C3lspclient.Lsp.Log
---The path to **c3-lsp** binary
---@field path? string
---Sends crash reports to server to help fixing bugs.
---@field sendCrashReports? boolean

---@class _.lspconfig.settings.c3_lsp.C3lspclient
---@field lsp? _.lspconfig.settings.c3_lsp.C3lspclient.Lsp

---@class lspconfig.settings.c3_lsp
---@field c3lspclient? _.lspconfig.settings.c3_lsp.C3lspclient
