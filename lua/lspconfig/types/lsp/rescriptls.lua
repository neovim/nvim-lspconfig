---@meta

---@class _.lspconfig.settings.rescriptls.Rescript.Settings.Cache.ProjectConfig
---Enable project config caching. Can speed up latency dramatically.
---
---```lua
---default = true
---```
---@field enable? boolean

---@class _.lspconfig.settings.rescriptls.Rescript.Settings.Cache
---@field projectConfig? _.lspconfig.settings.rescriptls.Rescript.Settings.Cache.ProjectConfig

---@class _.lspconfig.settings.rescriptls.Rescript.Settings.CompileStatus
---Show compile status in the status bar (compiling/errors/warnings/success).
---
---```lua
---default = true
---```
---@field enable? boolean

---@class _.lspconfig.settings.rescriptls.Rescript.Settings.IncrementalTypechecking
---(beta/experimental) Enable incremental type checking across files, so that unsaved file A gets access to unsaved file B.
---@field acrossFiles? boolean
---Enable incremental type checking.
---
---```lua
---default = true
---```
---@field enable? boolean

---@class _.lspconfig.settings.rescriptls.Rescript.Settings.InlayHints
---Enable (experimental) inlay hints.
---@field enable? boolean
---Maximum length of character for inlay hints. Set to null to have an unlimited length. Inlay hints that exceed the maximum length will not be shown.
---
---```lua
---default = 25
---```
---@field maxLength? integer

---@class _.lspconfig.settings.rescriptls.Rescript.Settings.SignatureHelp
---Enable signature help for function calls.
---
---```lua
---default = true
---```
---@field enabled? boolean
---Enable signature help for variant constructor payloads.
---
---```lua
---default = true
---```
---@field forConstructorPayloads? boolean

---@class _.lspconfig.settings.rescriptls.Rescript.Settings
---Whether you want the extension to prompt for autostarting a ReScript build if a project is opened with no build running.
---
---```lua
---default = true
---```
---@field askToStartBuild? boolean
---Path to the directory where cross-platform ReScript binaries are. You can use it if you haven't or don't want to use the installed ReScript from node_modules in your project.
---@field binaryPath? string
---@field cache? _.lspconfig.settings.rescriptls.Rescript.Settings.Cache
---Enable (experimental) code lens for function definitions.
---@field codeLens? boolean
---@field compileStatus? _.lspconfig.settings.rescriptls.Rescript.Settings.CompileStatus
---@field incrementalTypechecking? _.lspconfig.settings.rescriptls.Rescript.Settings.IncrementalTypechecking
---@field inlayHints? _.lspconfig.settings.rescriptls.Rescript.Settings.InlayHints
---Verbosity of ReScript language server logs sent to the Output channel.
---
---```lua
---default = "info"
---```
---@field logLevel? "error" | "warn" | "info" | "log"
---Path to the directory where platform-specific ReScript binaries are. You can use it if you haven't or don't want to use the installed ReScript from node_modules in your project.
---@field platformPath? string
---Optional path to the directory containing the @rescript/runtime package. Set this if your tooling is unable to automatically locate the package in your project.
---@field runtimePath? string
---@field signatureHelp? _.lspconfig.settings.rescriptls.Rescript.Settings.SignatureHelp

---@class _.lspconfig.settings.rescriptls.Rescript
---@field settings? _.lspconfig.settings.rescriptls.Rescript.Settings

---@class lspconfig.settings.rescriptls
---@field rescript? _.lspconfig.settings.rescriptls.Rescript
