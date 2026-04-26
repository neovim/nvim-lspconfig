---@meta

---@class _.lspconfig.settings.nil_ls.Nil.Diagnostics
---File globs to exclude from showing diagnostics
---
---```lua
---default = {}
---```
---@field excludedFiles? string
---Ignored diagnostic kinds
---
---```lua
---default = {}
---```
---@field ignored? string

---@class _.lspconfig.settings.nil_ls.Nil.Formatting
---External formatter command with arguments
---@field command? string[]

---@class _.lspconfig.settings.nil_ls.Nil.Nix
---The path to the `nix` binary
---
---```lua
---default = "nix"
---```
---@field binary? string

---@class _.lspconfig.settings.nil_ls.Nil.Server
---Path to the `nil` LSP server
---
---```lua
---default = "nil"
---```
---@field path? string

---@class _.lspconfig.settings.nil_ls.Nil
---@field diagnostics? _.lspconfig.settings.nil_ls.Nil.Diagnostics
---Enable `coc-nil` extension
---
---```lua
---default = true
---```
---@field enable? boolean
---@field formatting? _.lspconfig.settings.nil_ls.Nil.Formatting
---@field nix? _.lspconfig.settings.nil_ls.Nil.Nix
---@field server? _.lspconfig.settings.nil_ls.Nil.Server

---@class lspconfig.settings.nil_ls
---@field ["nil"]? _.lspconfig.settings.nil_ls.Nil
