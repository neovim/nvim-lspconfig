---@meta

---@class _.lspconfig.settings.nickel_ls.Nls.Server
---Logs the communication between VS Code and the language server.
---@field debugLog? boolean
---Path to nickel language server
---
---```lua
---default = "nls"
---```
---@field path? string
---Enables performance tracing to the given file
---@field trace? string

---@class _.lspconfig.settings.nickel_ls.Nls
---@field server? _.lspconfig.settings.nickel_ls.Nls.Server

---@class lspconfig.settings.nickel_ls
---@field nls? _.lspconfig.settings.nickel_ls.Nls
