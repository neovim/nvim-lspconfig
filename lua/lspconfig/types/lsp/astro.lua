---@meta

---@class _.lspconfig.settings.astro.Astro.AutoImportCache
---Enable the auto import cache. Yields a faster intellisense when automatically importing a file, but can cause issues with new files not being detected. Change is applied on restart. See [#1035](https://github.com/withastro/language-tools/issues/1035).
---
---```lua
---default = true
---```
---@field enabled? boolean

---@class _.lspconfig.settings.astro.Astro.LanguageServer
---Path to the language server executable. You won't need this in most cases, set this only when needing a specific version of the language server
---@field ["ls-path"]? string
---Path to the node executable used to execute the language server. You won't need this in most cases
---@field runtime? string

---@class _.lspconfig.settings.astro.Astro.Trace
---Traces the communication between VS Code and the language server.
---
---```lua
---default = "off"
---```
---@field server? "off" | "messages" | "verbose"

---@class _.lspconfig.settings.astro.Astro.UpdateImportsOnFileMove
---Controls whether the extension updates imports when a file is moved to a new location. In most cases, you'll want to keep this disabled as TypeScript and the Astro TypeScript plugin already handles this for you. Having multiple tools updating imports at the same time can lead to corrupted files.
---@field enabled? boolean

---@class _.lspconfig.settings.astro.Astro
---@field ["auto-import-cache"]? _.lspconfig.settings.astro.Astro.AutoImportCache
---Enable experimental support for content collection intellisense inside Markdown, MDX and Markdoc. Note that this require also enabling the feature in your Astro config (experimental.contentCollectionIntellisense) (Astro 4.14+)
---@field ["content-intellisense"]? boolean
---@field ["language-server"]? _.lspconfig.settings.astro.Astro.LanguageServer
---@field trace? _.lspconfig.settings.astro.Astro.Trace
---@field updateImportsOnFileMove? _.lspconfig.settings.astro.Astro.UpdateImportsOnFileMove

---@class lspconfig.settings.astro
---@field astro? _.lspconfig.settings.astro.Astro
